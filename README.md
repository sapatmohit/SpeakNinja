# 🥷 SpeakNinja - AI Chatbot Application

## 🚀 Overview
SpeakNinja is an AI-powered chatbot application designed to enhance English communication skills. Built using **Flutter** for a smooth cross-platform experience and **Firebase** for real-time data handling, SpeakNinja provides an intelligent, engaging, and responsive chatbot for learners.

## ✨ Features
- 🤖 **AI Chatbot** – Powered by Gemini AI for natural language conversations.  
- 📊 **Skill Assessment** – Uses BERT-based classification for user proficiency levels.  
- 🎨 **Cross-Platform UI** – Built with Flutter for seamless performance on Android & iOS.  
- ☁️ **Cloud-Backed Data** – Firebase integration for authentication, storage, and real-time database.  
- 🔌 **Smart AI Backend** – ML-based question-answering and interactive responses.  

## 📁 Project Structure
```plaintext
.
├── lib/                  # Flutter application source code
├── android/              # Android-specific files
├── ios/                  # iOS-specific files
├── functions/            # Firebase Cloud Functions (for AI backend logic)
├── assets/               # Images, fonts, and other assets
├── pubspec.yaml          # Flutter dependencies
├── README.md             # This file
└── .gitignore            # Git ignored files
```

## 🛠️ Installation
### 📌 Prerequisites
- 🖥️ Languages & Frameworks: Dart (Flutter), Firebase
- 📦 Tools Required: Flutter SDK, Firebase CLI, Android Studio/Xcode, Git
- 🔧 Firebase Services: Authentication, Firestore, Firebase Functions, Firebase Hosting

## ⚙️ Setup
- Clone the Repository
  ```code
  git clone https://github.com/yourusername/SpeakNinja.git
  ```
- Navigate to the Project Directory
  ```code
  cd SpeakNinja
  ```
- Install Flutter Dependencies
  ```code
  flutter pub get
  ```
- Set Up Firebase
  -  Create a Firebase project at Firebase Console.
  -  Download google-services.json (for Android) and GoogleService-Info.plist (for iOS).
  -  Place them inside android/app/ and ios/Runner/ respectively.
- Deploy Firebase Functions
  ```code
  cd functions
  npm install
  firebase deploy --only functions
  ```
## 🚀 Running SpeakNinja
- Run the App
  ```code
  flutter run
  ```

- Build for Release
  ```code
  flutter build apk  # For Android
  flutter build ios  # For iOS
  ```
