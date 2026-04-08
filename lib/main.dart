import 'package:flutter/widgets.dart';

import 'src/app/app_controller.dart';
import 'src/app/rc_heli_utils_app.dart';
import 'src/features/profiles/data/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = await ProfileRepository.create();
  final controller = AppController(repository: repository);
  await controller.load();

  runApp(RcHeliUtilsApp(controller: controller));
}
