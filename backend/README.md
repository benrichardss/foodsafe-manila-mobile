# FoodSafe Manila Backend

This backend is built with Express and MongoDB to support the Flutter frontend.

## Setup

1. Copy `.env.example` to `.env`.
2. Set `MONGO_URI` to your MongoDB connection string.
3. Run `npm install`.
4. Run `npm start` to launch the server.

## API Endpoints

- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/reset-password`
- `GET /api/auth/user/exists?phone=...`
- `PUT /api/users/:id`
- `POST /api/reports`
- `GET /api/reports/user/:userId`
- `GET /api/reports/user/:userId/last`
