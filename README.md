# Investor Deal Management App

A mini investor deal management app built with Flutter, focusing on clean architecture, BLoC state management, and a polished fintech UI.

## Features
- **Mock Authentication**: Login with session persistence using `shared_preferences`.
- **Deal Exploration**: Browse investment opportunities with key metrics (ROI, Risk, Investment).
- **Search & Filtering**: Real-time search and advanced filters for risk level and ROI.
- **Deal Details**: Comprehensive overview with static ROI projection charts using `fl_chart`.
- **Interest Management**: Save deals to "My Interests" locally.
- **Modern UI**: Clean, fintech-inspired design with Material 3 components.

## Architecture & Folder Structure
This project follows **Clean Architecture** principles, ensuring a clear separation of concerns:

- **Core**: Contains global configurations like `app_theme.dart`.
- **Data**: 
    - `models/`: Plain Dart classes for data structures (e.g., `Deal`).
    - `repositories/`: Handles data logic, mock API calls, and `shared_preferences`.
- **Logic (BLoC)**: 
    - Manages application state. We have `AuthBloc` for user sessions and `DealBloc` for all investment-related operations.
- **Presentation**: 
    - `screens/`: Individual pages (Login, Dashboard, Details).
    - `widgets/`: Reusable UI components like `DealCard`.

```text
lib/
├── core/               # Theme & Constants
├── data/
│   ├── models/         # Data Models
│   └── repositories/   # Data Sources & Mock APIs
├── logic/
│   └── blocs/          # BLoC State Management
└── presentation/
    ├── screens/        # UI Screens
    └── widgets/        # Reusable Widgets
```

## Decisions & Technical Choices
- **BLoC (Business Logic Component)**: Chosen for its robust separation of concerns and predictable state transitions.
- **Shared Preferences**: Used for persisting user session and interested deals.
- **Google Fonts**: `Inter` font family for a professional, modern look.
- **FL Chart**: Used for rendering ROI projections to provide a data-driven visual experience.

## Getting Started
1. Run `flutter pub get` to install dependencies.
2. Run the app using `flutter run`.

## Screenshots

<div align="center">
  <img src="screenshots/Screenshot 2026-07-05 102714.png" width="250" alt="Login & Dashboard">
  <img src="screenshots/Screenshot 2026-07-05 102725.png" width="250" alt="Deal Details">
  <img src="screenshots/Screenshot 2026-07-05 102735.png" width="250" alt="Filters & Interests">
</div>

