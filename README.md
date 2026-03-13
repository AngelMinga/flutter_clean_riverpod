# Flutter Clean Architecture with Riverpod

This project demonstrates a scalable Flutter application structure based on Clean Architecture principles and Provider for state management.

The goal is to create maintainable, testable, and modular Flutter applications by separating the code into independent layers.

## Architecture

The project follows a layered architecture:

- Presentation
- Domain
- Data

Each layer has a clear responsibility and communicates through well-defined abstractions.

## State Management

State management is implemented using Provider to keep the UI reactive and the business logic organized.

## Project Structure

## Project Structure

```
📁 project_root/
├── packages/                  # (optional if modularizing)
│   ├── core/                  # shared logic (usecases, utils, themes, constants, errors)
│   ├── features/
│   │   ├── user/
│   │   └── recipe/
│   └── shared_widgets/        # reusable UI components
│
├── lib/
│   ├── app.dart               # app configuration
│   ├── main.dart              # entry point
│   ├── routes/                # navigation
│   ├── core/
│   ├── features/
│   │   ├── user/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── recipe/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── shared/
│
├── test/
│   ├── features/
│   └── core/
│
├── pubspec.yaml
└── README.md
```

## Features

- Clean Architecture
- Provider state management
- Repository pattern
- Separation of concerns
- Scalable structure for large applications

## Purpose

This repository serves as a reference implementation for building Flutter applications using Clean Architecture and Provider.

