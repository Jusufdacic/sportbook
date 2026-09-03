# SportBook

A full-stack sports facility booking application with two clients — a REST API backend and a Flutter mobile app.

## Overview

SportBook lets users browse sports facilities, view available time slots, and book courts/fields. Bookings are confirmed via QR code, which staff can scan on-site to verify entry. 
The system supports role-based access, so administrators can manage facilities, equipment, and time slots separately from regular users.

## Tech Stack

**Backend**
- ASP.NET Core 8 (C#)
- Entity Framework Core
- SQL Server
- JWT authentication
- BCrypt password hashing

**Mobile App**
- Flutter (Dart)
- `http` package for REST API communication
- `shared_preferences` for local session storage
- `mobile_scanner` for QR code scanning
- `qr_flutter` for QR code generation

## Features

- User registration and login with JWT-based authentication
- Role-based authorization (regular users vs. administrators)
- Browse sports facilities, courts, and available time slots
- Create, view, and cancel reservations
- QR code generated per reservation, scanned on-site for entry verification
- Reviews and ratings for facilities
- Equipment rental as part of a reservation
- Admin panel for managing facilities, equipment, and working hours

## Project Structure

```
sportbook/
├── SportBookapp/SportBook/SportBook.API/   # ASP.NET Core backend
│   ├── Controllers/                         # API endpoints
│   ├── Models/                              # Database entities
│   ├── DTOs/                                # Data transfer objects
│   └── data/                                # EF Core DbContext
└── sportbook_app/                           # Flutter mobile app
    └── lib/
        ├── screens/                         # UI screens
        └── services/                        # API service layer
```

## Getting Started

### Backend

1. Navigate to the API project:
   ```
   cd SportBookapp/SportBook/SportBook.API
   ```
2. Update `appsettings.json` with your own SQL Server connection string and a JWT secret key (minimum 32 characters).
3. Apply database migrations:
   ```
   dotnet ef database update
   ```
4. Run the API:
   ```
   dotnet run
   ```

### Mobile App

1. Navigate to the app folder:
   ```
   cd sportbook_app
   ```
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Update the base URL in `lib/services/api_service.dart` to point to your running backend.
4. Run the app:
   ```
   flutter run
   ```

## Author

**Jusuf Dacić**
Computer Science & Information Technology graduate, Faculty of Traffic and Communications, University of Sarajevo
[GitHub](https://github.com/Jusufdacic)
