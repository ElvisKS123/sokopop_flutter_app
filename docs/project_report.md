# Sokopop Flutter App — Project Quality Assurance Report

**Submitted by:** Person 5 (QA & Documentation)  
**Date:** July 24, 2026  
**Project:** Sokopop Flutter Marketplace App

---

## 1. Executive Summary
Sokopop is a Flutter-based mobile marketplace application designed for ALU students to buy and sell items within their community. This report documents the quality assurance findings, testing results, and recommendations for the application submission.

---

## 2. Project Overview
### Purpose
Sokopop provides a student-friendly platform where ALU students can:
- Browse and search for listings in various categories
- Create and manage personal listings
- Sign in securely with email/password or Google authentication
- Communicate with sellers
- Track notifications and manage preferences

### Technology Stack
- **Frontend:** Flutter (Dart)
- **State Management:** Provider
- **Backend:** Firebase (Auth, Firestore)
- **Architecture:** Clean Architecture (presentation/domain/data layers)

---

## 3. Implemented Features

### 3.1 User Interface & Navigation
- ✓ Splash/onboarding screen
- ✓ Sign-in and sign-up flows
- ✓ Password reset functionality
- ✓ Home dashboard with bottom navigation
- ✓ Browse/search screen with filters
- ✓ Listing details view
- ✓ User profile and notifications screens
- ✓ Messaging and meetup coordination screens
- ✓ Consistent Material Design theme

### 3.2 Authentication & User Management
- ✓ Email/password registration and sign-in
- ✓ Google Sign-In integration
- ✓ Password reset via email
- ✓ User session persistence
- ✓ Email verification for new accounts
- ✓ SharedPreferences for storing preferences

### 3.3 Firebase Database & CRUD Operations
- ✓ Firestore integration for listings
- ✓ Create new listings with images and details
- ✓ Read listings with real-time updates
- ✓ Update listings (mark as sold)
- ✓ Delete listings
- ✓ User profiles stored in Firestore

### 3.4 State Management & Architecture
- ✓ Provider-based state management
- ✓ Separated business logic from UI
- ✓ Domain layer (use cases)
- ✓ Presentation layer (state)
- ✓ Data layer (repositories, services)
- ✓ Services abstraction for Firebase calls

---

## 4. Testing & Quality Validation

### 4.1 Widget Testing
Two automated widget tests were implemented to validate the UI layer:

```
flutter test
✓ Sokopop app shows the splash screen on launch
✓ Splash screen exposes the main onboarding actions
Result: 2 tests passed
```

**Screenshot of test execution:**
![Test Execution](../screenshots/test_run.png)

The tests verify that:
- The app initializes without Firebase errors during testing
- The splash screen renders with correct branding and text
- Onboarding buttons ("Get started" and "I already have an account") are present

### 4.2 Code Quality Analysis
The Flutter analyzer was run to identify code issues:

```
flutter analyze
Issues found: 55 (mostly informational warnings)
```

**Key findings:**
- 3 unused imports (needs cleanup)
- Multiple deprecated `withOpacity()` calls (should use `.withValues()`)
- Several unused private fields
- BuildContext usage across async gaps (needs `mounted` checks)
- Unnecessary use of multiple underscores

**Status:** Most issues are informational (info level) rather than breaking errors. The project is functional but requires code cleanup for production-ready status.

**Screenshot of analyzer output:**
![Analyzer Output](../screenshots/analyzer_output.png)

### 4.3 Manual Testing
- Verified splash screen and navigation flow
- Tested authentication screens (sign-in, sign-up, password reset)
- Confirmed listing browse and details screens render
- Validated bottom navigation between main screens
- Checked Firebase initialization and persistence

---

## 5. Project Structure (Clean Architecture)

```
lib/
├── data/                    # Data layer (repositories, services)
│   └── repositories/
├── domain/                  # Domain layer (use cases, business logic)
│   └── usecases/
├── presentation/            # Presentation layer (state management)
├── providers/               # Provider-based state
├── screens/                 # UI screens
├── widgets/                 # Reusable widgets
├── models/                  # Data models
├── services/                # Firebase services
├── theme/                   # App theming
└── utils/                   # Utilities and formatters
```

**Status:** The architecture follows clean separation of concerns, making the code maintainable and testable.

---

## 6. Firebase Security Rules (Summary)

The app requires Firestore security rules to protect user data. Recommended rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /listings/{listingId} {
      allow read: if request.auth.uid != null;
      allow create: if request.auth.uid != null;
      allow update, delete: if resource.data.sellerId == request.auth.uid;
    }
  }
}
```

---

## 7. Known Issues & Limitations

### Current Limitations
1. **Code Quality:** 55 analyzer issues (mostly style warnings) need cleanup before production
2. **Test Coverage:** Limited to smoke tests; lacks comprehensive unit/integration tests for auth and CRUD
3. **Error Handling:** Some screens lack proper error boundary handling
4. **UI Polish:** Responsive design needs validation on tablets and landscape modes
5. **Firebase Config:** Depends on proper Firebase setup for each platform (Android/iOS/Web)
6. **Deprecated APIs:** Multiple uses of deprecated Flutter color APIs

### Browser/Platform Constraints
- Google Sign-In requires proper OAuth configuration per platform
- Firebase must be initialized before the app starts
- Web version requires CORS-compliant Firebase setup

---

## 8. Future Improvements & Recommendations

### High Priority
- [ ] Fix deprecated `withOpacity()` → use `.withValues()`
- [ ] Remove unused imports and fields
- [ ] Add `mounted` checks for BuildContext usage across async gaps
- [ ] Implement Firebase security rules

### Medium Priority
- [ ] Expand widget test coverage (auth, CRUD operations)
- [ ] Add unit tests for providers and services
- [ ] Validate responsive layout on multiple screen sizes
- [ ] Improve error messages and user feedback

### Nice to Have
- [ ] Add integration tests with Firebase emulator
- [ ] Implement analytics tracking
- [ ] Add offline caching with Hive/SQLite
- [ ] Performance profiling and optimization

---

## 9. Testing Commands Summary

To run the same validation tests:

```bash
# Run widget tests
flutter test

# Run code analyzer
flutter analyze

# Format code
flutter format lib test

# Run with specific platform
flutter run -d android
flutter run -d ios
```

---

## 10. Contribution Summary by Role

| Role | Responsibility | Status |
|------|-----------------|--------|
| Person 1 | UI & Navigation | ✓ Complete |
| Person 2 | Authentication & Preferences | ✓ Complete |
| Person 3 | Firebase & CRUD | ✓ Complete |
| Person 4 | State Management & Architecture | ✓ Complete |
| Person 5 | Testing, Docs & QA | ✓ Complete |

---

## 11. Conclusion

The Sokopop Flutter application successfully demonstrates:
- ✓ A complete user authentication flow
- ✓ Real-time Firebase integration
- ✓ Clean state management with Provider
- ✓ Multi-screen navigation
- ✓ Clean architecture principles

**Assessment:** The app is **functionally complete** and meets all core rubric requirements. The project provides a strong foundation for a student marketplace platform. With the recommended code cleanups and expanded test coverage, this application is ready for academic submission.

---

## 12. Appendix: Screenshots

### Project Structure
![Project Structure](../screenshots/project_structure.png)

### Test Results
![Test Results](../screenshots/test_run.png)

### Code Quality Check
![Code Analysis](../screenshots/analyzer_output.png)

---

**Report Prepared:** July 24, 2026  
**Version:** 1.0
