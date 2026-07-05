# Investor Deal Management App

A mini investor deal management app built with Flutter, focusing on clean architecture, BLoC state management, and a polished fintech UI.

## Features
- **Mock Authentication**: Login with session persistence using `shared_preferences`.
- **Deal Exploration**: Browse investment opportunities with key metrics (ROI, Risk, Investment).
- **Search & Filtering**: Real-time search and advanced filters for risk level and ROI.
- **Deal Details**: Comprehensive overview with static ROI projection charts using `fl_chart`.
- **Interest Management**: Save deals to "My Interests" locally.
- **Modern UI**: Clean, fintech-inspired design with Material 3 components.

## Architecture
This project follows **Clean Architecture** principles:
- **Core**: Theme, constants, and utilities.
- **Data**:
    - **Models**: Data structures (Deal, RiskLevel, etc.).
    - **Repositories**: Data fetching logic and local storage abstraction (Simulating API with mock data).
- **Logic (BLoC)**:
    - `AuthBloc`: Manages authentication state and sessions.
    - `DealBloc`: Handles deal fetching, filtering, searching, and interest toggling.
- **Presentation**: UI components, screens, and custom widgets.

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

