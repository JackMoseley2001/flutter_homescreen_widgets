import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homescreen_widgets/homescreen_widgets.dart';

void main() {
  const MethodChannel channel = MethodChannel('homescreen_widgets');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
