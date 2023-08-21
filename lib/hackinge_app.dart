import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/routes/router.dart';
import 'features/auth/presentation/pages/mobile_page.dart';

class HackingeApp extends StatefulWidget {
  const HackingeApp({super.key});

  @override
  State<HackingeApp> createState() => _HackingeAppState();
}

class _HackingeAppState extends State<HackingeApp> {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HackInge',
      themeMode: ThemeMode.light,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
