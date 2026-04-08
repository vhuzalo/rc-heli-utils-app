import 'package:flutter/material.dart';

enum AppLanguage {
  ptBr(Locale('pt', 'BR')),
  en(Locale('en'));

  const AppLanguage(this.locale);

  final Locale locale;

  String get code => switch (this) {
        AppLanguage.ptBr => 'pt-BR',
        AppLanguage.en => 'en',
      };

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AppLanguage.ptBr,
    );
  }
}

class AppLocalizations {
  AppLocalizations(this.language);

  final AppLanguage language;

  static const _localizedValues = <String, Map<AppLanguage, String>>{
    'appTitle': {
      AppLanguage.ptBr: 'RC Heli Utils',
      AppLanguage.en: 'RC Heli Utils',
    },
    'home': {
      AppLanguage.ptBr: 'Inicio',
      AppLanguage.en: 'Home',
    },
    'bladeAngle': {
      AppLanguage.ptBr: 'Pitch gauge',
      AppLanguage.en: 'Pitch gauge',
    },
    'gearRatio': {
      AppLanguage.ptBr: 'Gear ratio',
      AppLanguage.en: 'Gear ratio',
    },
    'settings': {
      AppLanguage.ptBr: 'Config',
      AppLanguage.en: 'Settings',
    },
    'profiles': {
      AppLanguage.ptBr: 'Helis',
      AppLanguage.en: 'Helis',
    },
    'language': {
      AppLanguage.ptBr: 'Idioma',
      AppLanguage.en: 'Language',
    },
    'units': {
      AppLanguage.ptBr: 'Unidades',
      AppLanguage.en: 'Units',
    },
    'metric': {
      AppLanguage.ptBr: 'Metrico',
      AppLanguage.en: 'Metric',
    },
    'imperial': {
      AppLanguage.ptBr: 'Imperial',
      AppLanguage.en: 'Imperial',
    },
    'selectedProfile': {
      AppLanguage.ptBr: 'Heli selecionado',
      AppLanguage.en: 'Selected heli',
    },
    'selectedProfileNone': {
      AppLanguage.ptBr: 'Nenhum heli selecionado',
      AppLanguage.en: 'No heli selected',
    },
    'noProfileSelected': {
      AppLanguage.ptBr: 'Nenhum perfil selecionado',
      AppLanguage.en: 'No profile selected',
    },
    'openCalculator': {
      AppLanguage.ptBr: 'Abrir calculadora',
      AppLanguage.en: 'Open calculator',
    },
    'openMeter': {
      AppLanguage.ptBr: 'Abrir medidor',
      AppLanguage.en: 'Open angle meter',
    },
    'manageProfiles': {
      AppLanguage.ptBr: 'Gerenciar perfis',
      AppLanguage.en: 'Manage profiles',
    },
    'registeredProfiles': {
      AppLanguage.ptBr: 'Perfis cadastrados',
      AppLanguage.en: 'Saved profiles',
    },
    'createFirstProfileTitle': {
      AppLanguage.ptBr: 'Cadastre seu primeiro heli',
      AppLanguage.en: 'Create your first heli',
    },
    'createFirstProfileHint': {
      AppLanguage.ptBr: 'Comece salvando um perfil para reaproveitar medidas, calibracao e transmissao logo no primeiro uso.',
      AppLanguage.en: 'Start by saving a profile so you can reuse dimensions, calibration, and transmission data right away.',
    },
    'createFirstProfile': {
      AppLanguage.ptBr: 'Cadastrar heli',
      AppLanguage.en: 'Create heli',
    },
    'selectThisProfile': {
      AppLanguage.ptBr: 'Selecionar perfil',
      AppLanguage.en: 'Select profile',
    },
    'resume': {
      AppLanguage.ptBr: 'Resumo',
      AppLanguage.en: 'Summary',
    },
    'profilesEmpty': {
      AppLanguage.ptBr: 'Crie um perfil para reaproveitar medidas e transmissao.',
      AppLanguage.en: 'Create a profile to reuse blade and transmission values.',
    },
    'selectProfileHint': {
      AppLanguage.ptBr: 'Selecione um perfil cadastrado para carregar medidas e configuracoes salvas.',
      AppLanguage.en: 'Select a saved profile to load stored dimensions and settings.',
    },
    'calcMode': {
      AppLanguage.ptBr: 'Calculo',
      AppLanguage.en: 'Calculator',
    },
    'meterMode': {
      AppLanguage.ptBr: 'Medidor',
      AppLanguage.en: 'Meter',
    },
    'findDistance': {
      AppLanguage.ptBr: 'Calcular distancia',
      AppLanguage.en: 'Find tip distance',
    },
    'findAngle': {
      AppLanguage.ptBr: 'Calcular angulo',
      AppLanguage.en: 'Find angle',
    },
    'bladeLength': {
      AppLanguage.ptBr: 'Parafuso ate a ponta da pa',
      AppLanguage.en: 'Blade bolt to tip',
    },
    'targetAngle': {
      AppLanguage.ptBr: 'Angulo desejado',
      AppLanguage.en: 'Target angle',
    },
    'tipDistance': {
      AppLanguage.ptBr: 'Distancia entre pontas',
      AppLanguage.en: 'Tip-to-tip distance',
    },
    'calculate': {
      AppLanguage.ptBr: 'Calcular',
      AppLanguage.en: 'Calculate',
    },
    'formula': {
      AppLanguage.ptBr: 'Formula',
      AppLanguage.en: 'Formula',
    },
    'result': {
      AppLanguage.ptBr: 'Resultado',
      AppLanguage.en: 'Result',
    },
    'safeRange': {
      AppLanguage.ptBr: 'Faixa segura padrao: +/- 25 graus',
      AppLanguage.en: 'Default safe range: +/- 25 degrees',
    },
    'loadProfileValues': {
      AppLanguage.ptBr: 'Carregar perfil selecionado',
      AppLanguage.en: 'Load selected profile',
    },
    'saveToProfile': {
      AppLanguage.ptBr: 'Salvar no perfil selecionado',
      AppLanguage.en: 'Save to selected profile',
    },
    'selectProfileFirst': {
      AppLanguage.ptBr: 'Selecione um perfil para salvar os dados.',
      AppLanguage.en: 'Select a profile before saving data.',
    },
    'savedToProfile': {
      AppLanguage.ptBr: 'Dados atualizados no perfil.',
      AppLanguage.en: 'Profile updated.',
    },
    'sensorStatus': {
      AppLanguage.ptBr: 'Status do sensor',
      AppLanguage.en: 'Sensor status',
    },
    'sensorWaiting': {
      AppLanguage.ptBr: 'Aguardando leitura',
      AppLanguage.en: 'Waiting for samples',
    },
    'sensorActive': {
      AppLanguage.ptBr: 'Ativo',
      AppLanguage.en: 'Active',
    },
    'sensorUnavailable': {
      AppLanguage.ptBr: 'Indisponivel',
      AppLanguage.en: 'Unavailable',
    },
    'currentAngle': {
      AppLanguage.ptBr: 'Angulo atual',
      AppLanguage.en: 'Current angle',
    },
    'stability': {
      AppLanguage.ptBr: 'Estabilidade',
      AppLanguage.en: 'Stability',
    },
    'calibrateZero': {
      AppLanguage.ptBr: 'Calibrar zero',
      AppLanguage.en: 'Calibrate zero',
    },
    'clearCalibration': {
      AppLanguage.ptBr: 'Limpar zero',
      AppLanguage.en: 'Clear zero',
    },
    'saveZeroToProfile': {
      AppLanguage.ptBr: 'Salvar zero no perfil',
      AppLanguage.en: 'Save zero to profile',
    },
    'useProfileZero': {
      AppLanguage.ptBr: 'Usar zero do perfil',
      AppLanguage.en: 'Use profile zero',
    },
    'axis': {
      AppLanguage.ptBr: 'Eixo',
      AppLanguage.en: 'Axis',
    },
    'axisLongitudinal': {
      AppLanguage.ptBr: 'Longitudinal',
      AppLanguage.en: 'Longitudinal',
    },
    'axisLateral': {
      AppLanguage.ptBr: 'Lateral',
      AppLanguage.en: 'Lateral',
    },
    'meterHint': {
      AppLanguage.ptBr: 'Apoie o celular alinhado com a pa e calibre o zero antes de medir.',
      AppLanguage.en: 'Place the phone aligned to the blade and calibrate zero before measuring.',
    },
    'gearType': {
      AppLanguage.ptBr: 'Tipo de transmissao',
      AppLanguage.en: 'Gear train type',
    },
    'singleStage': {
      AppLanguage.ptBr: 'Um Estagio',
      AppLanguage.en: 'One stage',
    },
    'type1': {
      AppLanguage.ptBr: 'Dois Estagios',
      AppLanguage.en: 'Two stages',
    },
    'type2': {
      AppLanguage.ptBr: 'Dois estagios Tipo 2',
      AppLanguage.en: 'Two-stage Type 2',
    },
    'type3': {
      AppLanguage.ptBr: 'Dois estagios Tipo 3',
      AppLanguage.en: 'Two-stage Type 3',
    },
    'mainRatio': {
      AppLanguage.ptBr: 'Razao principal',
      AppLanguage.en: 'Main ratio',
    },
    'tailRatio': {
      AppLanguage.ptBr: 'Razao de cauda',
      AppLanguage.en: 'Tail ratio',
    },
    'rotorflightFields': {
      AppLanguage.ptBr: 'Campos Rotorflight',
      AppLanguage.en: 'Rotorflight fields',
    },
    'motorPinion': {
      AppLanguage.ptBr: 'Motor pinion',
      AppLanguage.en: 'Motor pinion',
    },
    'mainGear': {
      AppLanguage.ptBr: 'Main gear',
      AppLanguage.en: 'Main gear',
    },
    'tailPulley': {
      AppLanguage.ptBr: 'Tail pulley',
      AppLanguage.en: 'Tail pulley',
    },
    'frontPulley': {
      AppLanguage.ptBr: 'Front pulley',
      AppLanguage.en: 'Front pulley',
    },
    'gearTypeHint': {
      AppLanguage.ptBr: 'Preencha os dentes Z1...Zn conforme o diagrama do tipo escolhido.',
      AppLanguage.en: 'Fill Z1...Zn according to the selected gear diagram.',
    },
    'name': {
      AppLanguage.ptBr: 'Nome',
      AppLanguage.en: 'Name',
    },
    'model': {
      AppLanguage.ptBr: 'Modelo',
      AppLanguage.en: 'Model',
    },
    'brand': {
      AppLanguage.ptBr: 'Marca',
      AppLanguage.en: 'Brand',
    },
    'heliClass': {
      AppLanguage.ptBr: 'Classe',
      AppLanguage.en: 'Class',
    },
    'marketPreset': {
      AppLanguage.ptBr: 'Pre-cadastro de mercado',
      AppLanguage.en: 'Market preset',
    },
    'marketPresetHint': {
      AppLanguage.ptBr: 'Escolha uma marca, o modelo e a relacao de transmissao ja cadastrada para preencher o perfil com dados de fabrica.',
      AppLanguage.en: 'Choose a brand, model, and saved transmission setup to prefill the profile with factory data.',
    },
    'applyPreset': {
      AppLanguage.ptBr: 'Usar pre-cadastro',
      AppLanguage.en: 'Apply preset',
    },
    'presetModel': {
      AppLanguage.ptBr: 'Modelo',
      AppLanguage.en: 'Model',
    },
    'gearPreset': {
      AppLanguage.ptBr: 'Relacao',
      AppLanguage.en: 'Gear ratio',
    },
    'addProfile': {
      AppLanguage.ptBr: 'Novo perfil',
      AppLanguage.en: 'New profile',
    },
    'editProfile': {
      AppLanguage.ptBr: 'Editar perfil',
      AppLanguage.en: 'Edit profile',
    },
    'deleteProfile': {
      AppLanguage.ptBr: 'Excluir perfil',
      AppLanguage.en: 'Delete profile',
    },
    'save': {
      AppLanguage.ptBr: 'Salvar',
      AppLanguage.en: 'Save',
    },
    'cancel': {
      AppLanguage.ptBr: 'Cancelar',
      AppLanguage.en: 'Cancel',
    },
    'chooseProfile': {
      AppLanguage.ptBr: 'Escolher perfil',
      AppLanguage.en: 'Choose profile',
    },
    'profileBladeLength': {
      AppLanguage.ptBr: 'Comprimento da pa',
      AppLanguage.en: 'Blade length',
    },
    'profileUpdatedAt': {
      AppLanguage.ptBr: 'Atualizado',
      AppLanguage.en: 'Updated',
    },
    'measurementMagnitudeNote': {
      AppLanguage.ptBr: 'O calculo por distancia retorna a magnitude do angulo.',
      AppLanguage.en: 'Distance-based calculation returns the angle magnitude.',
    },
    'invalidRadius': {
      AppLanguage.ptBr: 'Informe um comprimento de pa maior que zero.',
      AppLanguage.en: 'Enter a blade length greater than zero.',
    },
    'invalidAngle': {
      AppLanguage.ptBr: 'Informe um angulo dentro da faixa segura configurada.',
      AppLanguage.en: 'Enter an angle inside the configured safe range.',
    },
    'invalidDistance': {
      AppLanguage.ptBr: 'A distancia informada e impossivel para este comprimento de pa.',
      AppLanguage.en: 'The distance is impossible for this blade length.',
    },
    'missingValue': {
      AppLanguage.ptBr: 'Preencha o valor necessario para o calculo.',
      AppLanguage.en: 'Fill the required value for the calculation.',
    },
    'invalidTeeth': {
      AppLanguage.ptBr: 'Todos os dentes devem ser maiores que zero.',
      AppLanguage.en: 'All tooth counts must be greater than zero.',
    },
    'profileSavedZero': {
      AppLanguage.ptBr: 'Zero salvo no perfil.',
      AppLanguage.en: 'Calibration saved to profile.',
    },
    'profileLoadHint': {
      AppLanguage.ptBr: 'Use um perfil para reaproveitar medidas, zero do sensor e transmissao.',
      AppLanguage.en: 'Use a profile to reuse dimensions, sensor zero and transmission data.',
    },
    'type1Diagram': {
      AppLanguage.ptBr: 'Z1->Z2 | Z3 coaxial com Z2 | Z4 principal | Z5 frontal de cauda | Z6 traseira',
      AppLanguage.en: 'Z1->Z2 | Z3 shares shaft with Z2 | Z4 main | Z5 tail front | Z6 tail rear',
    },
    'type2Diagram': {
      AppLanguage.ptBr: 'Z1->Z2 | Z3 coaxial com Z2 | Z4 principal | Z5 frontal de cauda | Z6 traseira',
      AppLanguage.en: 'Z1->Z2 | Z3 shares shaft with Z2 | Z4 main | Z5 tail front | Z6 tail rear',
    },
    'type3Diagram': {
      AppLanguage.ptBr: 'Z1->Z2 | Z3 coaxial com Z2 | Z4 principal | Z5 cauda 1 | Z6 frontal 2 | Z7 traseira 2',
      AppLanguage.en: 'Z1->Z2 | Z3 shares shaft with Z2 | Z4 main | Z5 tail 1 | Z6 front 2 | Z7 rear 2',
    },
    'singleStageDiagram': {
      AppLanguage.ptBr: 'Z1 pinhao motor | Z2 engrenagem principal | Z3 frontal/autorotacao | Z4 traseira/cauda',
      AppLanguage.en: 'Z1 motor pinion | Z2 main gear | Z3 front/autorotation | Z4 rear/tail',
    },
    'noProfilesYet': {
      AppLanguage.ptBr: 'Nenhum perfil salvo ainda.',
      AppLanguage.en: 'No saved profiles yet.',
    },
    'deleteConfirm': {
      AppLanguage.ptBr: 'Excluir este perfil?',
      AppLanguage.en: 'Delete this profile?',
    },
    'bladeAndTransmission': {
      AppLanguage.ptBr: 'Pa e transmissao',
      AppLanguage.en: 'Blade and transmission',
    },
    'lastCalibration': {
      AppLanguage.ptBr: 'Ultimo zero',
      AppLanguage.en: 'Last zero',
    },
  };

  String text(String key) {
    return _localizedValues[key]?[language] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    final localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localization != null, 'AppLocalizations not found in widget tree.');
    return localization!;
  }

  static const delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLanguage.values.any(
      (language) =>
          language.locale.languageCode == locale.languageCode &&
          (language.locale.countryCode == null ||
              language.locale.countryCode == locale.countryCode),
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final language = AppLanguage.values.firstWhere(
      (item) => item.locale.languageCode == locale.languageCode,
      orElse: () => AppLanguage.ptBr,
    );
    return AppLocalizations(language);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
