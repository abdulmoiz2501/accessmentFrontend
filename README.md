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

## API Endpoints

### Authentication
- `POST /api/auth/login` - Login with username and password
- `POST /api/auth/logout` - Logout (requires authentication)

### Grammar Check
- `POST /api/grammar/check` - Check grammar and spelling (requires authentication)

## Deployment

### Backend Deployment

Deploy the backend to:
- Render.com
- Railway.app
- Vercel
- Heroku
- Any Node.js hosting platform

Update the `baseUrl` in `lib/core/constants/api.dart` after deployment.

### Flutter App Deployment

Build APK:
```bash
flutter build apk --release
```

Build iOS:
```bash
flutter build ios --release
```

## Technologies Used

### Frontend
- Flutter
- GetX (State Management & Navigation)
- Dio (HTTP Client)
- SharedPreferences (Local Storage)

### Backend
- Node.js
- Express.js
- OpenAI API
- JWT (Authentication)

## Development Guidelines

### Controller Initialization Pattern

Always initialize controllers at the top of each View:

```dart
final MyController controller = Get.isRegistered<MyController>()
    ? Get.find<MyController>()
    : Get.put(MyController());
```

### State Management Rules

- ✅ Use Rx variables: `final count = 0.obs;`
- ✅ Use Obx() for reactive UI updates
- ✅ Use GetBuilder() for manual rebuilds
- ❌ NEVER use setState
- ❌ NEVER use GetX Bindings
- ❌ NEVER use GoRouter

### Constants Usage

Always import from centralized constants:
- `AppColors` for colors
- `AppAssets` for asset paths
- `Api` for API endpoints

## Testing

Run tests:
```bash
flutter test
```

## License

This project is created for assessment purposes.

## Contact

For questions or issues, please contact the development team.
