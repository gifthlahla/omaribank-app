# Omari Bank - Running Instructions

## Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.11.4 or higher)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- An IDE like VS Code, Android Studio, or IntelliJ IDEA
- For iOS: Xcode (macOS only)
- For Android: Android SDK and Android Studio

## Project Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Build Verification

The project has been tested and builds successfully:

```bash
# For Windows (Desktop)
flutter build windows --debug

# For Web
flutter build web

# For Android
flutter build apk

# For iOS (macOS only)
flutter build ios
```

## Running the App

### Desktop (Windows)

```bash
flutter run -d windows
```

This will launch the app on your Windows desktop.

### Web (Chrome/Firefox)

```bash
flutter run -d chrome
# or
flutter run -d edge
```

The app will open in your default browser.

### Android Emulator

First, ensure you have an Android emulator running:

```bash
flutter emulators
flutter emulators launch <emulator_name>
```

Then run:

```bash
flutter run
```

### Physical Android Device

Connect your device via USB and enable USB debugging, then:

```bash
flutter run
```

### iOS (macOS only)

```bash
flutter run -d ios
```

## Application Features

### ✅ Implemented Features

**Authentication**
- User registration with email, password, full name, and optional phone number
- User login with email and password
- Session persistence via Supabase auth state
- Form validation with helpful error messages
- Secure password visibility toggle

**Wallet Management**
- Real-time wallet balance display using Supabase streams
- Automatic balance updates when transactions occur
- Loading skeletons during async operations

**Money Operations**
- **Send Money (Peer-to-Peer):** Transfer funds to another user by recipient ID
- **Deposit:** Simulate depositing money into your wallet
- **Withdraw:** Simulate withdrawing money from your wallet
- All operations use Supabase RPC functions for security
- Confirmation dialogs before executing transactions
- Success/error feedback with snackbars

**Transaction History**
- Real-time transaction list with auto-updates
- View all sent, received, deposited, and withdrawn transactions
- Transaction details screen with full information
- Transaction status display (completed, pending, failed)
- Pull-to-refresh functionality
- Skeleton loaders for better UX

**Profile & Settings**
- View user profile information (name, email, phone)
- Settings menu (expandable for edit profile, security, notifications)
- Logout with confirmation dialog
- Avatar with user initials fallback

**UI/UX**
- Clean card-based design
- Light and dark theme support
- Responsive layout
- Real-time updates powered by Supabase streams
- Loading states and error handling throughout

## Backend Configuration

The app connects to **Supabase** with the following credentials:

```
Supabase URL: https://illrfnelbgikxgsooaej.supabase.co
Anonkey: sb_publishable_-3NhKiyRw_QGyV4SW16pfw_4gyMz1sj
```

All database operations are configured to:
- Use Row-Level Security (RLS) for data privacy
- Execute money operations via secure PostgreSQL RPC functions
- Subscribe to real-time updates for wallet and transaction data

## Test Users

The following test users are available in the backend:

| Email | Password | Notes |
|-------|----------|-------|
| gifthlahla@omaribank.com | gift1234 | Initial balance: $100 |
| test2@omaribank.com | Test123! | Initial balance: $100 |

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app/
│   ├── app.dart             # Root widget
│   └── app_router.dart      # GoRouter navigation configuration
├── core/
│   ├── constants/           # App strings, colors, constants
│   ├── theme/               # Light/dark themes
│   ├── utils/               # Formatters, validators, extensions
│   └── widgets/             # Reusable widgets (shimmer, dialogs, etc.)
├── features/
│   ├── auth/                # Authentication (login/register)
│   ├── wallet/              # Wallet display and balance
│   ├── transactions/        # Money operations and history
│   └── profile/             # User profile screen
└── shared/
    └── services/            # Supabase initialization
```

## Troubleshooting

### App won't run

1. Ensure Flutter SDK is properly installed:
   ```bash
   flutter doctor
   ```

2. If there are missing dependencies:
   ```bash
   flutter pub get
   flutter clean
   flutter pub get
   ```

3. Check for compilation errors:
   ```bash
   flutter analyze
   ```

### Build errors on Windows

Ensure Visual Studio Build Tools are installed. Run:
```bash
flutter doctor -v
```

### Connection issues with Supabase

- Verify your internet connection
- Check that the Supabase credentials in `lib/core/constants/app_constants.dart` are correct
- Ensure Supabase backend is online

### Real-time updates not working

- Check your internet connection
- Verify that Supabase Realtime is enabled on your project
- Check browser/app console for errors

## Building for Production

### Web

```bash
flutter build web --release
```

Output will be in `build/web/`

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-app.apk`

### Android App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

### Windows

```bash
flutter build windows --release
```

Output will be in `build/windows/x64/runner/Release/`

### iOS (macOS only)

```bash
flutter build ios --release
```

Then archive using Xcode for App Store submission.

## Code Quality

The project follows Flutter best practices:

- **Clean Architecture:** Separated into data, domain, and presentation layers
- **State Management:** Riverpod for reactive state management
- **Routing:** GoRouter for type-safe navigation
- **Form Validation:** Input validation with user-friendly error messages
- **Error Handling:** Comprehensive error handling with user feedback
- **Real-time Updates:** Supabase streams for live data synchronization

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

---

**Build Status:** ✅ All compilation checks passed
**Last Updated:** April 16, 2026
