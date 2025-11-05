# Grammar Checker Backend API

Backend API for the Grammar Checker mobile application.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file based on `.env.example`:
```bash
cp .env.example .env
```

3. Update the `.env` file with your values:
- `PORT`: Server port (default: 3000)
- `JWT_SECRET`: Secret key for JWT tokens
- `OPENAI_API_KEY`: Your OpenAI API key

## Running

Development mode:
```bash
npm run dev
```

Production mode:
```bash
npm start
```

## API Endpoints

### Health Check
- `GET /api/health` - Check if API is running

### Authentication
- `POST /api/auth/login` - Login with username and password
  - Body: `{ "username": "admin", "password": "admin123" }`
  - Returns: `{ "token": "...", "user": { "id": "...", "username": "...", "email": "..." } }`

- `POST /api/auth/logout` - Logout (requires authentication)
  - Headers: `Authorization: Bearer <token>`

### Grammar Check
- `POST /api/grammar/check` - Check grammar and spelling (requires authentication)
  - Headers: `Authorization: Bearer <token>`
  - Body: `{ "text": "This is a test sentense for gramer checking." }`
  - Returns: `{ "correctedText": "...", "errors": [...] }`

## Default Users

- Username: `admin`, Password: `admin123`
- Username: `user`, Password: `user123`

## Deployment

This backend can be deployed to:
- Render.com
- Railway.app
- Vercel
- Heroku
- Any Node.js hosting platform

Make sure to set environment variables in your hosting platform.

