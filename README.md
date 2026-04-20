# Paddy

Paddy is a Flutter-based Final Year Project mobile application designed to help paddy farmers monitor crop health, detect leaf diseases using AI, and manage daily farm activities in one place.

## Problem Statement

Paddy farmers often face challenges in identifying crop diseases early and consistently managing daily field tasks. Manual observation may delay intervention, causing reduced yield and crop quality. This project addresses the need for a practical digital tool that combines disease detection, recommendations, and task management in a single mobile app.

## Project Objectives

- Build a user-friendly mobile app for paddy disease support.
- Implement AI-based rice leaf disease detection using TensorFlow Lite.
- Provide disease descriptions and practical treatment recommendations.
- Store scan history for tracking and future reference.
- Support daily farm planning with task and calendar features.

## Key Features

### 1) Authentication and User Account

- Splash screen and authentication gate.
- User registration and login using Firebase Authentication.
- Forgot password email reset flow.
- User profile information stored in Cloud Firestore.

### 2) AI Disease Detection

- Capture leaf image from camera or upload from gallery.
- On-device inference using TFLite model.
- Label mapping via JSON file.
- Prediction result page with:
  - disease name
  - detailed disease explanation
  - actionable recommendations
  - condition info tags

### 3) Scan History

- Save each scan result to Firestore.
- Track previous scans with timestamp.
- View full result details from history.
- Delete history entries when needed.

### 4) Dashboard Insights

- Curated paddy-related news card.
- Weather integration (OpenWeather API).
- Calendar quick access.
- Disease trend chart from user history (bar chart).

### 5) Task and Calendar Management

- Add daily tasks with date and time.
- View tasks by selected date.
- Mark tasks complete/incomplete.
- Delete tasks with confirmation.
- Progress tracking with completion percentage.

### 6) Profile and Support

- Edit profile details (name, phone, address).
- Invite friends via share link, WhatsApp, and QR code.
- Submit user feedback.
- In-app help center (FAQ), privacy policy, and terms page.

## Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase Authentication, Cloud Firestore, Firebase Core
- **Machine Learning:** TensorFlow Lite (`tflite_flutter`)
- **Image/Input:** `image_picker`, camera/gallery workflow
- **Networking:** `http` (weather API)
- **Visualization/UI:** `fl_chart`, `percent_indicator`, `intl`
- **Utility Packages:** `share_plus`, `url_launcher`, `qr_flutter`

## Data Structure Overview

- `users/{uid}`: user profile info (name, email, phone, address)
- `users/{uid}/history/{doc}`: scan history (image path, prediction, recommendation, timestamp)
- `users/{uid}/tasks/{doc}`: tasks (title, note, date, time, done status)
- `feedback/{doc}`: feedback records submitted by users

## Application Flow

1. User opens app and passes splash/auth gate.
2. User logs in or creates an account.
3. User scans paddy leaf image (camera/gallery).
4. App predicts disease and shows recommendations.
5. User saves result to history.
6. User manages daily tasks through calendar/task modules.
7. User tracks insights from dashboard (weather + disease trends).

## Screenshots

Add your screenshots here for better presentation:

- Login / Register page
- Dashboard
- Scan page
- Scan result page
- History page
- Calendar / Task page
- Profile page

Example:

```md
![Dashboard](assets/screenshots/dashboard.png)
![Scan Result](assets/screenshots/scan_result.png)
```

## Setup and Run

### Prerequisites

- Flutter SDK installed
- Dart SDK (comes with Flutter)
- Android Studio or VS Code
- Firebase project configured

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/aqilroslan/paddy.git
   cd paddy
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Future Improvements

- Add multilingual support (Bahasa Melayu / English).
- Add role support (farmer, agronomist, admin).
- Improve model accuracy with larger local dataset.
- Add cloud image backup for history.
- Push notifications for scheduled tasks and reminders.

## Author

Final Year Project by **Aqil Roslan**.

GitHub Repository: [aqilroslan/paddy](https://github.com/aqilroslan/paddy)
