# SubMan

SubMan is a standalone Android application designed for efficient subscription management and expense tracking. It provides users with a comprehensive overview of their recurring digital services, automated payment calculations, and a calendar-based visualization of upcoming obligations.

## Core Features

- **Subscription Overview**: A centralized dashboard displaying active subscriptions, upcoming payments for the week, and total monthly expenditure.
- **Calendar Integration**: Visual representation of payment dates with logic to handle monthly, yearly, and weekly recurring cycles.
- **Service Customization**: Extensive library of predefined service icons, categorizations, and support for custom image uploads from local storage.
- **Search and Filter**: Advanced search capabilities to filter subscriptions by name or description across primary and historical records.
- **Dark Mode Support**: Context-aware theme engine with support for system-wide settings or manual overrides.
- **Local Data Persistence**: Highly efficient local storage implementation using SQLite to ensure data privacy and offline availability.

## Visual Interface

Placeholder for UI Overview Screenshot
<!-- [IMAGE_PLACEHOLDER: home_screen_overview] -->

Placeholder for Feature Interaction Screenshots
<!-- [IMAGE_PLACEHOLDER: add_subscription_screen] -->
<!-- [IMAGE_PLACEHOLDER: calendar_view_screen] -->

## Technical Implementation

The application is built using the following architecture and technologies:

- **Framework**: Flutter (Dart)
- **State Management**: Provider Pattern
- **Local Database**: Sqflite (SQLite)
- **Preferences**: Shared Preferences for configuration persistence
- **UI Components**: Custom design system including a premium credit-card styled hero interface
