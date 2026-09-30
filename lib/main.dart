import 'package:flutter/material.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';
import 'package:tenet_finance/core/database/hive_service.dart';
import 'package:tenet_finance/features/Navigation/ui/views/app_init_view.dart';
import 'package:tenet_finance/features/Navigation/ui/views/navigation_view.dart';


Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
}

Future<void> main() async {
  await bootstrap();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TenetEssentialTheme(
      theme: TenetEssentialThemeData(fontFamily: 'yekan'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Directionality(
          textDirection: TextDirection.rtl,
          child: AppInitView(child: const NavView()),
        ),
      ),
    );
  }
}
