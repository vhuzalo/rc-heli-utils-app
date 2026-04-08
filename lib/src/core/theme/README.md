# RC Heli Utils

Flutter app for RC helicopter setup and quick reference.

The goal of the project is to keep useful setup tools in a simple interface, with local helicopter profiles and reusable data shared across calculators.

## Features

- blade angle calculator
- accelerometer-based blade angle meter
- Rotorflight-aligned gear ratio calculator
- local per-heli profiles
- home screen with a list of saved profiles
- preloaded market models with transmission presets stored in a project file

## Market Presets

The project now includes a local database of preloaded helicopter models in [assets/model_presets.json](C:\Users\vhuza\Documents\RC Heli Utils\assets\model_presets.json).

For each model, the file stores:

- brand, model, variant, and class
- main blade and tail blade ranges
- transmission type
- saved pinion/gear combinations
- `mainRatio` and `tailRatio`
- source references used to build the preset
- notes describing verified or inferred data

In the profile create/edit flow, the app reads these presets and lets the user choose:

- brand
- preloaded model
- preloaded transmission setup

When a preset is applied, the profile is automatically filled with a base name, transmission type, and the tooth counts for the selected setup.

## Included Models

Current starter database:

- `XLPower`: `Specter 700 V2`, `Nimbus 550 V2`
- `Align`: `T-Rex 700XN`, `T-Rex 550X`, `T-Rex 470LT`
- `Tron`: `7.0 Dnamic`, `5.5 Orion Gemini`
- `Gaui`: `X7`
- `SAB`: `Goblin RAW 700`

Notes:

- not every manufacturer publishes every tooth count with the same level of detail
- when a preset relies on inference from official published ratios, that should be documented in the preset `notes` field

## Structure

- `lib/src/app`: bootstrap, global state, and main shell
- `lib/src/core`: localization, theme, and base utilities
- `lib/src/features/blade_angle`: blade angle calculator and angle meter
- `lib/src/features/gear_ratio`: gear ratio calculator
- `lib/src/features/home`: main screen and navigation
- `lib/src/features/profiles`: local profiles, editor, and preset loading
- `assets/model_presets.json`: local database of preloaded models and transmission setups
- `test/`: business logic and persistence tests

## Important Files

- [lib/src/features/profiles/data/model_preset_repository.dart](C:\Users\vhuza\Documents\RC Heli Utils\lib\src\features\profiles\data\model_preset_repository.dart): loads presets from the local asset file
- [lib/src/features/profiles/domain/heli_model_preset.dart](C:\Users\vhuza\Documents\RC Heli Utils\lib\src\features\profiles\domain\heli_model_preset.dart): schema for preloaded model presets
- [lib/src/features/profiles/presentation/profiles_screen.dart](C:\Users\vhuza\Documents\RC Heli Utils\lib\src\features\profiles\presentation\profiles_screen.dart): profile editor with preset selection

## How To Expand The Database

To add new models:

1. add a new item to `assets/model_presets.json`
2. include the source in the `sources` array
3. fill in tooth counts, `mainRatio`, and `tailRatio`
4. use `notes` whenever there is any inference or special caution

Suggested quality rules:

- prioritize official manuals and manufacturer pages
- use mirrors such as ManualsLib only as support when the official manual is not easily accessible
- avoid filling models with guessed data

## Running The App

If the environment is not fully initialized yet, use:

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

To validate the project:

```bash
flutter test
dart analyze
```

## Note

In this environment, commands such as `flutter test`, `dart analyze`, and `dart format` may take too long or hit timeout limits. If that happens, run validation directly on the host machine with the Flutter SDK configured.
