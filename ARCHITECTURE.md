# SokoPop — architecture

Flutter + Firebase, Clean Architecture, Provider / ChangeNotifier.
Read this before adding a feature.

## The dependency rule

```
presentation  ──▶  domain  ◀──  data
 (Provider)        (pure)      (Firebase)
```

Arrows point **inward**. `domain/` imports nothing from `data/` or
`presentation/`. The practical test:

```bash
grep -r "firebase\|cloud_firestore\|package:flutter" lib/features/*/domain/
```

That returns nothing but a doc comment. Delete Firebase from `pubspec.yaml` and
every file under any `domain/` folder still compiles.

It works because `domain` *declares* the interface (`AuthRepository`,
`ListingRepository`) and `data` *implements* it.
`core/di/service_locator.dart` connects the two at runtime.

| Layer | Holds | May import | Must never import |
|---|---|---|---|
| `domain` | entities, repository interfaces, use cases | nothing | Flutter, Firebase |
| `data` | models, data sources, repository impls | domain | widgets, BuildContext |
| `presentation` | providers, screens, widgets | domain | Firebase, raw queries |

## Structure

```
lib/
├── main.dart                 Firebase init → DI init → runApp
├── app.dart                  MultiProvider + MaterialApp + AuthGate
│
├── core/
│   ├── di/service_locator.dart      every registration, one file
│   ├── error/failures.dart          what presentation is allowed to see
│   ├── error/auth_error_mapper.dart Firebase codes → user-facing copy
│   ├── router/app_routes.dart       route names
│   ├── theme/app_theme.dart
│   └── utils/formatters.dart
│
├── features/
│   ├── auth/
│   │   ├── data/          remote + local data sources, UserModel, repo impl
│   │   ├── domain/        AppUser, AuthRepository, 7 use cases
│   │   └── presentation/  AuthProvider, 4 screens
│   ├── listings/
│   │   ├── data/          data source, ListingModel, repo impl
│   │   ├── domain/        Listing, ListingRepository, 6 use cases
│   │   └── presentation/  ListingProvider, 4 screens
│   ├── messaging/         chat + messages screens
│   ├── meetup/
│   └── profile/           profile + notifications screens
│
└── shared/
    ├── mock/mock_data.dart   demo data, clearly quarantined
    └── widgets/              cross-feature widgets
```

`messaging/`, `meetup/` and `profile/` deliberately have only `presentation/`.
Those screens still render demo data from `shared/mock/`; there is no Firestore
behind them, so there is nothing to put in `data/` and no rules for `domain/`.
Empty folders would imply a layer that does not exist. They grow the other two
folders when someone wires them up.

All intra-project imports are `package:sokopop_flutter_app/...` rather than
`../../..`, so moving a file no longer breaks a dozen import paths.

## How errors travel

```
FirebaseAuthException('invalid-credential')     ← the SDK throws
  ↓ AuthRepositoryImpl._guard catches it
AuthFailure('Incorrect email or password.')     ← already worded for a user
  ↓ AuthProvider._run catches Failure
errorMessage = failure.message
  ↓
snackbar
```

The screens never see a Firebase type, and the switch over error codes exists
once, in `core/error/auth_error_mapper.dart`.

Same for Firestore. The old code surfaced
`Exception: Failed to create listing: [cloud_firestore/permission-denied] ...`
straight into a snackbar; `ListingRepositoryImpl` now turns that into
`PermissionFailure`.

## State management

Provider + ChangeNotifier, with dependencies injected by `get_it`.

**Why not BLoC.** The brief allows an alternative, and the team had already
built 14 screens on Provider. Migrating would have meant rewriting teammates'
graded work to swap one library for another with no functional gain. The thing
actually missing was not the library — it was the layering.

**Providers no longer construct their own data layer.** The old code had:

```dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();   // untestable
```

Presentation was building its own Firebase-backed dependency, so neither class
could be tested in isolation. Now every dependency arrives through the
constructor and `service_locator.dart` decides what gets injected.

`ListingProvider` is created with `ChangeNotifierProxyProvider<AuthProvider, …>`
so it always knows the signed-in user's id without importing anything from the
auth feature's data layer.

### What belongs in `setState`, and what does not

Kept in widgets, because it is ephemeral and dies with the screen:
`_obscurePass`, the tab index, the image-carousel index, `_isSearching`.

Moved into providers and use cases, because it decides *what data a user sees*
or *whether an action is allowed*: category filter, verified-only toggle, sort
order, search query, submit-in-flight flags, ownership checks.

## Testing

```bash
flutter test
```

Four suites, all of which were impossible before the refactor because the logic
lived inside widgets:

- `filter_listings_test.dart` — browse filtering and sorting
- `listing_test.dart` — `isOwnedBy`, status helpers, `copyWith`
- `sign_in_with_email_test.dart` — validation, against a mock repository
- `app_user_test.dart` — initials and the `@alustudent.com` rule

`test/widget_test.dart` is skipped with a note explaining how to un-skip it: it
pumps `SokopopApp`, which needs the service locator populated first.

## Security rules

`firestore.rules` is new — the repo had none. It enforces:

1. Only signed-in users read anything.
2. `sellerId` must equal the caller's uid on create, and cannot be changed.
3. `createdAt` must be a server timestamp (`request.time`) and is immutable.
4. Only the seller can update or delete their listing.
5. A user cannot set `isVerifiedStudent` on themselves.
6. Everything unmatched is denied.

```bash
firebase emulators:start --only firestore    # test locally first
firebase deploy --only firestore:rules,firestore:indexes
```

`firestore.indexes.json` declares the two composite indexes the browse and
"my listings" queries need. Without them Firestore returns `failed-precondition`.

## Known follow-ups

- `home_screen.dart` still renders `sampleListings` from `shared/mock/` in
  places and keeps a local `_selectedCategory`.
- `messaging/` and `profile/` screens are entirely mock-backed.
- Dark mode / theme preference is not implemented. `AuthLocalDataSource` is the
  pattern to copy for it.
- Google sign-in needs a web client ID in `web/index.html` and a registered
  SHA-1 fingerprint per developer for Android.
- The portrait-only lock was removed from `main.dart`; screens now need
  checking for overflow in landscape.
