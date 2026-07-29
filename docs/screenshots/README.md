# Screenshots Directory

This folder contains evidence screenshots for the QA report. Save the following files here:

## Required Screenshots

### 1. test_run.png
Widget test execution output showing:
- "All tests passed!" or test results
- Command: `flutter test`
- Shows the 2 widget tests passing

**File:** `test_run.png`

### 2. analyzer_output.png
Flutter analyzer output showing:
- Code quality issues found
- Command: `flutter analyze`
- Shows lint warnings and info messages

**File:** `analyzer_output.png`

### 3. project_structure.png
Project file structure from VS Code Explorer showing:
- lib/ folder with subdirectories
- data/, domain/, presentation/, screens/, etc.
- Demonstrates clean architecture organization

**File:** `project_structure.png`

## Optional Screenshots

- **auth_flow.png** - Sign-in/sign-up screens
- **home_screen.png** - Main app dashboard
- **listings_screen.png** - Browse listings UI
- **firebase_console.png** - Firestore data validation

---

**Note:** Place PNG images in this folder. The report references them with relative paths like `../screenshots/test_run.png`.
