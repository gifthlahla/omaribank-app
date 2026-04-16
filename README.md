# Omari Bank

A modern mobile banking application built with Flutter and Supabase. Omari Bank provides a seamless digital wallet experience with real-time balance updates, peer-to-peer transfers, and comprehensive transaction history.

<p align="center">
  <img src="assets/images/logo.png" alt="Omari Bank Logo" width="150"/>
</p>

## ✨ Features

- 🔐 **Secure Authentication** – Email/password signup and login with Supabase Auth
- 💰 **Real-Time Wallet** – Live balance updates using Supabase Realtime subscriptions
- 💸 **P2P Transfers** – Send money to other users instantly
- 📊 **Transaction History** – View all transactions with real-time updates
- 📥 **Deposits & Withdrawals** – Simulated funding operations
- 🎨 **Modern UI** – Clean, card-based design with skeleton loaders and pull-to-refresh
- 🌙 **Dark Mode Support** – Full light/dark theme compatibility

## 📱 Screenshots

| Home | Transactions | Send Money | Profile |
|------|--------------|------------|---------|
| ![Home](screenshots/home.png) | ![Transactions](screenshots/transactions.png) | ![Send](screenshots/send.png) | ![Profile](screenshots/profile.png) |

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Frontend** | Flutter (iOS & Android) |
| **Backend** | Supabase (PostgreSQL) |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **Real-time** | Supabase Realtime |
| **Database** | PostgreSQL (via Supabase) |
| **Authentication** | Supabase Auth |

## 📁 Project Structure
lib/
├── main.dart # App entry point
├── app/
│ ├── app.dart # MaterialApp configuration
│ └── app_router.dart # GoRouter routes
├── core/
│ ├── constants/ # App constants, colors, strings
│ ├── theme/ # Light/dark theme definitions
│ ├── utils/ # Formatters, validators, extensions
│ └── widgets/ # Reusable UI components
├── features/
│ ├── auth/ # Authentication feature
│ │ ├── data/ # Repositories
│ │ ├── domain/ # Models
│ │ └── presentation/ # Screens, providers, widgets
│ ├── wallet/ # Wallet/dashboard feature
│ ├── transactions/ # Transactions feature
│ └── profile/ # User profile feature
└── shared/
└── services/ # Shared services (e.g., Supabase client)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode (for emulators)
- Supabase account (backend already configured)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/gifthlahla/omaribank-app.git
   cd omaribank-app
