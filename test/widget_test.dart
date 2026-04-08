import 'package:flutter_test/flutter_test.dart';
import 'package:rc_heli_utils/src/app/app_controller.dart';
import 'package:rc_heli_utils/src/app/rc_heli_utils_app.dart';
import 'package:rc_heli_utils/src/features/profiles/data/profile_repository.dart';

void main() {
  testWidgets('renders app shell', (WidgetTester tester) async {
    final controller = AppController(repository: ProfileRepository(_MemoryStore()));
    await controller.load();

    await tester.pumpWidget(RcHeliUtilsApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Blade Angle'), findsWidgets);
    expect(find.text('Gear Ratio'), findsWidgets);
    expect(find.text('Profiles'), findsWidgets);
  });
}

class _MemoryStore implements KeyValueStore {
  final _data = <String, String>{};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }
}
