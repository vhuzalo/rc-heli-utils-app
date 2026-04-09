# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projeto

App Flutter (Dart 3.4+) de utilitários para setup de helimodelos RC. Plataformas: Android e iOS. Persistência local via SharedPreferences, sem backend.

## Comandos

```bash
# Dependências
flutter pub get

# Rodar o app
flutter run

# Testes
flutter test
flutter test test/blade_angle/blade_angle_service_test.dart  # teste específico

# Análise estática e formatação
dart analyze
dart format lib

# Build de release (Android)
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Build iOS
flutter build ios --release --no-codesign   # sem assinatura (teste)
flutter build ipa --release                  # IPA assinado (requer provisioning)
```

**Nota:** comandos Flutter podem demorar ou dar timeout em ambientes restritos. Se acontecer, rodar na máquina host.

## Arquitetura

### Estado global
`AppController` (ChangeNotifier) exposto via `AppScope` (InheritedNotifier). Acesso: `AppScope.of(context)`. Gerencia perfis, idioma, unidade de medida e perfil selecionado.

### Estrutura de features
Cada feature segue `domain/ → data/ → presentation/` (nem todas têm `data/`):
- **blade_angle**: calculadora de passo + medidor via acelerômetro (sensors_plus). `BladeAngleService` faz cálculos trigonométricos puros. `AngleMeterController` gerencia stream do sensor com filtro low-pass.
- **gear_ratio**: calculadora de relação de transmissão com 4 tipos (single-stage, two-stage types 1/2/3). `GearRatioService` com fórmulas por tipo. Saída compatível com Rotorflight.
- **profiles**: CRUD de perfis locais + presets de 35 modelos de mercado carregados de `assets/model_presets.json`. Persistência em `ProfileRepository` (SharedPreferences → JSON).
- **home**: shell de navegação (bottom nav bar) + lista de perfis.
- **settings**: idioma (pt-BR/en) e sistema de unidades (métrico/imperial).

### Localização
Classe customizada `AppLocalizations` em `lib/src/core/localization/` com dicionário inline (pt-BR e en). Acesso via `context.l10n`.

### Tema
Material Design 3 customizado em `lib/src/core/theme/app_theme.dart`. Primária: #FF6A1A (laranja), secundária: #00A3FF (azul).

## Convenções

- Aspas simples obrigatórias (`prefer_single_quotes` no analysis_options.yaml)
- Lints: `package:flutter_lints/flutter.yaml`
- Services são stateless e testáveis isoladamente
- Exceções customizadas com enum de error codes (`BladeAngleException`, `GearRatioException`)
- Unidades sempre armazenadas em milímetros internamente; conversão imperial apenas na UI
- Um perfil ativo por vez — calculadoras pré-preenchem a partir dele

## Expandir base de presets

Adicionar modelos em `assets/model_presets.json` com `sources` e `notes`. Priorizar manuais oficiais. Documentar inferências no campo `notes`.

## iOS

- `NSMotionUsageDescription` em `ios/Runner/Info.plist` — obrigatório para acelerômetro (sensors_plus)
- Ícones gerados via `flutter_launcher_icons` a partir de `assets/app_icon.png`
- Após alterar dependências nativas: `cd ios && pod install`
- CI/CD iOS ainda não implementado (requer Apple Developer Program + macOS runner)

## CI/CD

GitHub Actions em `.github/workflows/android-apk-release.yml`. Disparo manual ou por tag `v*`. Suporta assinatura via secrets (`ANDROID_KEYSTORE_BASE64`, etc.) com fallback para debug signing.
