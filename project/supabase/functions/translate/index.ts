import { createClient } from 'npm:@supabase/supabase-js@2.39.0';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

async function translateText(text: string, sourceLang: string, targetLang: string) {
  const url = 'https://translation.googleapis.com/language/translate/v2';
  const apiKey = Deno.env.get('GOOGLE_TRANSLATE_API_KEY');

  if (!apiKey) {
    throw new Error('Translation API key not configured');
  }

  const params = new URLSearchParams({
    q: text,
    target: targetLang,
    source: sourceLang,
    key: apiKey,
  });

  const response = await fetch(`${url}?${params}`);
  const data = await response.json();

  if (!response.ok) {
    throw new Error(data.error?.message || 'Translation failed');
  }

  return data.data.translations[0].translatedText;
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    );

    const { data: { user }, error: authError } = await supabaseClient.auth.getUser();

    if (authError || !user) {
      throw new Error('Unauthorized');
    }

    const { text, sourceLang, targetLang } = await req.json();

    if (!text || !sourceLang || !targetLang) {
      throw new Error('Missing required parameters');
    }

    const translatedText = await translateText(text, sourceLang, targetLang);

    // Store translation in database
    const { error: insertError } = await supabaseClient
      .from('translations')
      .insert({
        user_id: user.id,
        source_text: text,
        translated_text: translatedText,
        source_language: sourceLang,
        target_language: targetLang,
      });

    if (insertError) {
      throw new Error('Failed to save translation');
    }

    return new Response(
      JSON.stringify({ translatedText }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: error.message === 'Unauthorized' ? 401 : 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  }
});