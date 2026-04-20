/*
  # Translation System Schema

  1. New Tables
    - `languages`
      - `id` (uuid, primary key)
      - `code` (text, unique) - ISO language code
      - `name` (text) - Language name in English
      - `native_name` (text) - Language name in its native script
      - `created_at` (timestamp)

    - `translations`
      - `id` (uuid, primary key)
      - `user_id` (uuid) - References auth.users
      - `source_text` (text) - Original text
      - `translated_text` (text) - Translated text
      - `source_language` (text) - References languages.code
      - `target_language` (text) - References languages.code
      - `created_at` (timestamp)
      - `is_favorite` (boolean)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users
*/

-- Create languages table
CREATE TABLE IF NOT EXISTS languages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  native_name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create translations table
CREATE TABLE IF NOT EXISTS translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  source_text text NOT NULL,
  translated_text text NOT NULL,
  source_language text REFERENCES languages(code) NOT NULL,
  target_language text REFERENCES languages(code) NOT NULL,
  created_at timestamptz DEFAULT now(),
  is_favorite boolean DEFAULT false
);

-- Enable RLS
ALTER TABLE languages ENABLE ROW LEVEL SECURITY;
ALTER TABLE translations ENABLE ROW LEVEL SECURITY;

-- Languages policies
CREATE POLICY "Languages are viewable by everyone"
  ON languages
  FOR SELECT
  TO authenticated
  USING (true);

-- Translations policies
CREATE POLICY "Users can view their own translations"
  ON translations
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own translations"
  ON translations
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own translations"
  ON translations
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own translations"
  ON translations
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Insert default languages
DO $$
BEGIN
  INSERT INTO languages (code, name, native_name) VALUES
    ('en', 'English', 'English'),
    ('es', 'Spanish', 'Español'),
    ('fr', 'French', 'Français'),
    ('de', 'German', 'Deutsch'),
    ('it', 'Italian', 'Italiano'),
    ('pt', 'Portuguese', 'Português'),
    ('ru', 'Russian', 'Русский'),
    ('ja', 'Japanese', '日本語'),
    ('zh', 'Chinese (Simplified)', '简体中文'),
    ('ar', 'Arabic', 'العربية'),
    ('hi', 'Hindi', 'हिन्दी'),
    ('ko', 'Korean', '한국어'),
    ('tr', 'Turkish', 'Türkçe'),
    ('vi', 'Vietnamese', 'Tiếng Việt'),
    ('th', 'Thai', 'ไทย'),
    ('nl', 'Dutch', 'Nederlands'),
    ('sv', 'Swedish', 'Svenska'),
    ('fi', 'Finnish', 'Suomi'),
    ('pl', 'Polish', 'Polski')
  ON CONFLICT (code) DO NOTHING;
END $$;