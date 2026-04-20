 Language Translation Chatbot

A cross-platform language translation chatbot built using Flutter (frontend) and Python (backend), powered by Hugging Face translation models like Helsinki-NLP. The application enables real-time multilingual communication through an interactive chat interface.

🚀 Features
Real-time text translation
Chatbot-style conversational UI
Support for multiple languages
Fast and accurate translations using Hugging Face models
Cross-platform mobile application (Android/iOS)
REST API integration between Flutter and Python backend
🛠️ Tech Stack

Frontend:

Flutter
Dart

Backend:

Python
Flask / FastAPI

AI/NLP:

Hugging Face Transformers
Helsinki-NLP Translation Models
📂 Project Structure

language-translation-chatbot/

│
├── frontend/ # Flutter App
│ ├── lib/
│ └── pubspec.yaml

│
├── backend/ # Python API
│ ├── app.py
│ ├── requirements.txt

│
└── README.md

⚙️ Installation & Setup
1. Clone the repository

git clone https://github.com/your-username/language-translation-chatbot.git

cd language-translation-chatbot

2. Backend Setup (Python)

cd backend
pip install -r requirements.txt

Create a .env file and add your Hugging Face API key:

HF_API_KEY=your_secret_key_here

Run the backend server:

python app.py

3. Frontend Setup (Flutter)

cd frontend
flutter pub get
flutter run

🔄 How It Works
User enters text in the Flutter app
Request is sent to Python backend via REST API
Backend calls Hugging Face translation model (Helsinki-NLP)
Translated text is returned to frontend
Output is displayed in chat interface
🔐 Environment Variables

HF_API_KEY → Hugging Face API secret key

📸 Screenshots (Optional)

Add your app screenshots here

🚧 Future Enhancements
Voice-to-text translation
Text-to-speech output
More language support
AI conversational responses
🤝 Contributing

Contributions are welcome! Feel free to fork the repository and submit a pull request.

📄 License

This project is licensed under the MIT License.

👨‍💻 Author

Developed by R. Sai Nethra
