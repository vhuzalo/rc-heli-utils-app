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

## APK Distribution For Testers

For the first test releases, the simplest flow is to publish an APK directly in a GitHub Release and share that release URL.

This repository now includes a workflow at [.github/workflows/android-apk-release.yml](C:\Users\vhuza\Documents\RC Heli Utils\.github\workflows\android-apk-release.yml) that:

- builds `flutter build apk --release`
- uploads the APK as a workflow artifact
- attaches the APK to a GitHub Release

You can trigger it in two ways:

- manually in `Actions > Android APK Release`
- automatically when pushing a tag like `v0.1.0`

### Recommended Signing Setup

The Android project supports a local release keystore via [android/key.properties.example](C:\Users\vhuza\Documents\RC Heli Utils\android\key.properties.example).

1. create your keystore
2. copy `android/key.properties.example` to `android/key.properties`
3. fill in `storePassword`, `keyPassword`, `keyAlias`, and `storeFile`
4. keep both the keystore and `key.properties` out of git

If no release keystore is configured, the app still builds using the debug signing config. That is acceptable for quick internal tests, but for wider distribution the recommended path is a real release keystore.

### GitHub Secrets

To generate signed APKs in GitHub Actions, add these repository secrets:

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

The `ANDROID_KEYSTORE_BASE64` value should be the Base64 content of your `.jks` file.

### Suggested Test Release Flow

1. update `version:` in [pubspec.yaml](C:\Users\vhuza\Documents\RC Heli Utils\pubspec.yaml)
2. commit the changes
3. push to GitHub
4. create and push a tag such as `v0.1.0`
5. wait for the `Android APK Release` workflow to finish
6. copy the GitHub Release link and share it with testers

### Local APK Build

To build the same package locally:

```bash
flutter pub get
flutter build apk --release
```

The generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Note

In this environment, commands such as `flutter test`, `dart analyze`, and `dart format` may take too long or hit timeout limits. If that happens, run validation directly on the host machine with the Flutter SDK configured.
