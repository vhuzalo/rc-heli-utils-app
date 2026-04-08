# RC Heli Utils

Aplicativo Flutter para setup e consulta rápida de helimodelos RC.

O objetivo do projeto é concentrar ferramentas úteis de configuração em uma interface simples, com perfis locais de helicópteros e dados reaproveitáveis entre as calculadoras.

## Baixar o APK da Última Release

Para instalar a versão de testes mais recente, acesse a última release publicada no GitHub:

[Baixar último APK](https://github.com/vhuzalo/rc-heli-utils-app/releases/latest)

Na página da release, baixe o arquivo `rc_heli_utils.apk` na seção de assets.

## Funcionalidades

- calculadora de passo das pás
- medidor de passo usando o acelerômetro do celular
- calculadora de relação de transmissão alinhada ao Rotorflight
- perfis locais por helicóptero
- tela inicial com lista de perfis salvos
- modelos de mercado pré-carregados com presets de transmissão em arquivo local

## Presets de Mercado

O projeto inclui uma base local de modelos pré-carregados em [assets/model_presets.json](C:\Users\vhuza\Documents\RC Heli Utils\assets\model_presets.json).

Para cada modelo, o arquivo armazena:

- marca, modelo, variante e classe
- faixas de tamanho de pá principal e de cauda
- tipo de transmissão
- combinações salvas de pinhão e engrenagem
- `mainRatio` e `tailRatio`
- referências de origem usadas para montar o preset
- observações descrevendo dados verificados ou inferidos

No fluxo de criação e edição de perfil, o app lê esses presets e permite escolher:

- marca
- modelo pré-carregado
- configuração de transmissão pré-carregada

Quando um preset é aplicado, o perfil é preenchido automaticamente com nome base, tipo de transmissão e contagens de dentes da configuração escolhida.

## Modelos Incluídos

Atualmente o app inclui `35` presets de modelos, organizados por marca:

- `Align`: `T-Rex 470L (Dominator)`, `T-Rex 470LT (Dominator)`, `T-Rex 500X (Belt Version)`, `T-Rex 550X (Dominator)`, `T-Rex 600XN (Dominator)`, `T-Rex 700 Nitro Pro (M1)`, `T-Rex 700E (DFC)`, `T-Rex 700N (DFC)`, `T-Rex 700XN (Dominator)`
- `Gaui`: `X3 (Basic Kit)`, `X4 II (FBL)`, `X5 (Formula)`, `X5 (Lite)`, `X7 (Flybarless)`
- `Goosky`: `RS4 (Legend Venom)`, `RS5 (Legend)`, `RS6 (Legend)`, `RS7 (Legend)`
- `SAB`: `Black Thunder 700`, `Goblin 500 Sport`, `ilGoblin 700 RAW/PRO`, `RAW 580`, `RAW 580 Nitro`, `RAW 700`, `RAW 700 Nitro`, `RAW Piuma`
- `Tron`: `5.5 Orion Gemini (Standard)`, `7.0 Dnamic (Standard)`
- `XLPower`: `Nimbus 550 (V2 Nitro)`, `Nimbus 550 (V2)`, `Specter 700 (V1)`, `Specter 700 (V2 Nitro Ultimate)`, `Specter 700 (V2)`, `Wraith E 760 (V3)`, `XL 550 (XL55V2K01)`

Observações:

- nem todo fabricante publica todas as contagens de dentes com o mesmo nível de detalhe
- quando um preset depende de inferência com base em relações publicadas oficialmente, isso deve ser documentado no campo `notes`

## Estrutura

- `lib/src/app`: bootstrap, estado global e shell principal
- `lib/src/core`: localização, tema e utilitários base
- `lib/src/features/blade_angle`: calculadora de passo e medidor de passo
- `lib/src/features/gear_ratio`: calculadora de relação de transmissão
- `lib/src/features/home`: tela principal e navegação
- `lib/src/features/profiles`: perfis locais, editor e carregamento de presets
- `assets/model_presets.json`: base local de modelos e configurações de transmissão
- `test/`: testes de regra de negócio e persistência

## Arquivos Importantes

- [lib/src/features/profiles/data/model_preset_repository.dart](C:\Users\vhuza\Documents\RC Heli Utils\lib\src\features\profiles\data\model_preset_repository.dart): carrega os presets a partir do asset local
- [lib/src/features/profiles/domain/heli_model_preset.dart](C:\Users\vhuza\Documents\RC Heli Utils\lib\src\features\profiles\domain\heli_model_preset.dart): esquema dos presets de modelos pré-carregados
- [lib/src/features/profiles/presentation/profiles_screen.dart](C:\Users\vhuza\Documents\RC Heli Utils\lib\src\features\profiles\presentation\profiles_screen.dart): editor de perfis com seleção de presets

## Como Expandir a Base

Para adicionar novos modelos:

1. adicione um novo item em `assets/model_presets.json`
2. inclua a fonte no array `sources`
3. preencha contagens de dentes, `mainRatio` e `tailRatio`
4. use `notes` sempre que houver inferência ou algum cuidado especial

Regras de qualidade sugeridas:

- priorize manuais oficiais e páginas dos fabricantes
- use fontes secundárias, como ManualsLib, apenas como apoio quando o manual oficial não estiver facilmente disponível
- evite preencher modelos com dados chutados

## Como Rodar o App

Se o ambiente ainda não estiver totalmente inicializado, use:

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

Para validar o projeto:

```bash
flutter test
dart analyze
```

## Distribuição de APK para Testes

Para as primeiras versões de teste, o fluxo mais simples é publicar o APK diretamente em uma GitHub Release e compartilhar o link dessa release.

Este repositório inclui o workflow [.github/workflows/android-apk-release.yml](C:\Users\vhuza\Documents\RC Heli Utils\.github\workflows\android-apk-release.yml), que:

- executa `flutter build apk --release`
- envia o APK como artifact do workflow
- anexa o APK a uma GitHub Release

Você pode disparar esse processo de duas formas:

- manualmente em `Actions > Android APK Release`
- automaticamente ao enviar uma tag como `v0.1.0`

### Configuração Recomendada de Assinatura

O projeto Android suporta uma keystore local de release usando [android/key.properties.example](C:\Users\vhuza\Documents\RC Heli Utils\android\key.properties.example).

1. crie sua keystore
2. copie `android/key.properties.example` para `android/key.properties`
3. preencha `storePassword`, `keyPassword`, `keyAlias` e `storeFile`
4. mantenha a keystore e o `key.properties` fora do git

Se nenhuma keystore de release estiver configurada, o app ainda pode ser gerado com a assinatura de debug. Isso serve para testes internos rápidos, mas para distribuição mais ampla o ideal é usar uma keystore de release real.

### Secrets do GitHub

Para gerar APKs assinados no GitHub Actions, adicione estes secrets no repositório:

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

O valor de `ANDROID_KEYSTORE_BASE64` deve ser o conteúdo em Base64 do arquivo `.jks`.

### Fluxo Sugerido de Release de Teste

1. atualize a linha `version:` em [pubspec.yaml](C:\Users\vhuza\Documents\RC Heli Utils\pubspec.yaml)
2. faça commit das mudanças
3. envie para o GitHub
4. crie e envie uma tag como `v0.1.0`
5. aguarde a conclusão do workflow `Android APK Release`
6. compartilhe o link da GitHub Release com os testers

### Build Local do APK

Para gerar localmente o mesmo pacote:

```bash
flutter pub get
flutter build apk --release
```

O APK gerado ficará em:

```text
build/app/outputs/flutter-apk/rc_heli_utils.apk
```

## Observação

Neste ambiente, comandos como `flutter test`, `dart analyze` e `dart format` podem demorar demais ou atingir timeout. Se isso acontecer, rode a validação diretamente na máquina host com o Flutter SDK configurado.
