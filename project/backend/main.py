from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import httpx
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TranslationRequest(BaseModel):
    text: str
    source_language: str
    target_language: str

class DetectionRequest(BaseModel):
    text: str

@app.get("/")
async def read_root():
    return {"message": "Translation API is running"}

@app.post("/translate")
async def translate_text(request: TranslationRequest):
    try:
        api_key = os.getenv("HUGGINGFACE_API_KEY")
        if not api_key:
            raise HTTPException(status_code=500, detail="Hugging Face API key not configured")

        # Supported Helsinki models
        model_map = {
            ("es", "en"): "Helsinki-NLP/opus-mt-es-en",
            ("en", "es"): "Helsinki-NLP/opus-mt-en-es",
            ("fr", "en"): "Helsinki-NLP/opus-mt-fr-en",
            ("en", "fr"): "Helsinki-NLP/opus-mt-en-fr",
            # Add more pairs as needed
        }
        model_name = model_map.get((request.source_language, request.target_language))
        if not model_name:
            raise HTTPException(status_code=400, detail="Language pair not supported")

        model_url = f"https://api-inference.huggingface.co/models/{model_name}"

        headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
        payload = {
            "inputs": request.text
        }

        async with httpx.AsyncClient() as client:
            response = await client.post(model_url, headers=headers, json=payload)
            if response.status_code != 200:
                raise HTTPException(
                    status_code=response.status_code,
                    detail=f"{response.status_code}: Translation failed: {response.reason_phrase or response.text}"
                )
            translation = response.json()
            if isinstance(translation, list) and len(translation) > 0 and "translation_text" in translation[0]:
                return {"translation": translation[0]["translation_text"]}
            else:
                raise HTTPException(status_code=500, detail=f"Unexpected response from Hugging Face API: {translation}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/detect-language")
async def detect_language(request: DetectionRequest):
    try:
        api_key = os.getenv("HUGGINGFACE_API_KEY")
        if not api_key:
            raise HTTPException(status_code=500, detail="Hugging Face API key not configured")

        model_url = "https://api-inference.huggingface.co/models/papluca/xlm-roberta-base-language-detection"
        headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
        payload = {
            "inputs": request.text
        }

        async with httpx.AsyncClient() as client:
            response = await client.post(model_url, headers=headers, json=payload)
            if response.status_code != 200:
                raise HTTPException(
                    status_code=response.status_code,
                    detail="Language detection failed"
                )

            predictions = response.json()
            if (
                isinstance(predictions, list)
                and len(predictions) > 0
                and isinstance(predictions[0], list)
                and len(predictions[0]) > 0
            ):
                top_prediction = max(predictions[0], key=lambda x: x['score'])
                return {
                    "detectedLanguage": top_prediction['label'].lower(),
                    "confidence": top_prediction['score']
                }
            else:
                raise HTTPException(status_code=400, detail="Could not detect language")

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)


