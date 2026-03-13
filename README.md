# clean_provider

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


📁 project_root/
├── packages/                  # (opcional si decides modularizar)
│   ├── core/                  # lógica compartida (usecases, utils, themes, constants, error)
│   ├── features/              # cada feature puede ser un package
│   │   ├── user/
│   │   └── recipe/
│   └── shared_widgets/        # componentes UI comunes reutilizables
│
├── lib/
│   ├── app.dart               # Configuración general de la app
│   ├── main.dart              # Punto de entrada
│   ├── routes/                # Navegación (AppRouter, GoRouter, etc.)
│   ├── core/                  # Si no modularizas aún
│   ├── features/
│   │   ├── user/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── recipe/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── shared/                # temas, widgets, constantes compartidas
│
├── test/
│   ├── features/
│   └── core/
│
├── pubspec.yaml
└── README.md

