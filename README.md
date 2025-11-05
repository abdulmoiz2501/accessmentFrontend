# Grammar Checker App

A Flutter mobile application for grammar and spelling checking with AI-powered corrections using OpenAI API.

## Features

- ✅ **Authentication**: Login and logout functionality
- ✅ **Grammar Checking**: Real-time grammar and spelling checking
- ✅ **Error Highlighting**: Visual highlighting of incorrect words
- ✅ **Suggestions**: Tap on errors to see correction suggestions
- ✅ **Live Preview**: See corrections as you type

## Architecture

The app follows **MVC architecture with GetX** for state management:

- **State Management**: GetX (Rx observables, Obx, GetBuilder)
- **Navigation**: GetX navigation (Get.toNamed, Get.offNamed, etc.)
- **No setState**: All state management is done through GetX
- **No GoRouter**: Using GetX's own navigation system

## Project Structure

```
lib/
├── core/
│   ├── constants/        # API endpoints, colors, assets
│   ├── services/         # API service, user service, shared prefs
│   └── widgets/          # Reusable widgets
├── features/
│   ├── auth/            # Authentication feature
│   ├── home/            # Home screen
│   └── grammar/         # Grammar checking feature
└── main.dart            # App entry point
```

## Setup

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd testing
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Backend URL is already configured in `lib/core/constants/api.dart`:
```dart
static const String baseUrl = 'https://nodes-iota.vercel.app/api';
```

4. Run the app:
```bash
flutter run
```

## Backend Setup

The backend is located in the `backend/` directory. See [backend/README.md](backend/README.md) for setup instructions.

### Quick Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```bash
cp .env.example .env
```

4. Update `.env` with your OpenAI API key:
```
OPENAI_API_KEY=your-openai-api-key
JWT_SECRET=your-secret-key
PORT=3000
```

5. Run the server:
```bash
npm start
# or for development
npm run dev
```

## Default Login Credentials

- **Username**: `admin`
- **Password**: `admin123`

OR

- **Username**: `user`
- **Password**: `user123`



### Flutter App Deployment

Build APK:
```bash
flutter build apk --release
```



