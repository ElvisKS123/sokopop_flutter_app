# Sokopop Flutter App

Sokopop is a Flutter + Firebase marketplace app for ALU students. This repository includes the app UI, authentication flow, Firestore-backed listing features, and the quality-assurance setup used for the project submission.

## Project setup

1. Install Flutter SDK 3.11+ and ensure it is on your PATH.
2. Clone the repository and run:
   ```bash
   flutter pub get
   ```
3. Start Firebase for the platform you are testing on:
   - Android/iOS: use the Firebase project configuration already linked to the app.
   - Web: the app uses the configured web Firebase options in the main entry point.
4. Run the app locally:
   ```bash
   flutter run
   ```

## Running tests

```bash
flutter test
```

## Code quality checks

```bash
flutter analyze
flutter format lib test
```

## Firebase security rules (summary)

The app should only allow authenticated users to read and write their own profile data and listing records. In production, add Firestore security rules that:

- restrict users collection updates to the signed-in user’s own document
- validate listing fields before writes
- prevent anonymous or unauthenticated access to protected collections

## Known limitations

- Google Sign-In depends on the correct Firebase OAuth configuration for the platform being tested.
- The app currently uses the default Firebase initialization flow and should be extended with environment-specific configuration for production releases.
- Some UI polish and edge-case validation can still be improved after the core functional requirements are complete.

## Contribution tracker

- UI and navigation work: screen implementation and responsive layout updates
- Authentication and preferences: email/password, Google Sign-In, password reset, and SharedPreferences handling
- Firebase CRUD: Firestore integration and create/read/update/delete flows
- State management and architecture: Provider-based state management and structured screens/services
- Testing and documentation: widget tests, unit tests, linting, and project documentation

## Report template

A starter report outline is available in [docs/report_template.md](docs/report_template.md).
