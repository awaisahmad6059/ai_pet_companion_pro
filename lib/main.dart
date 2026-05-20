import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/core/theme/app_theme.dart';
import 'package:ai_pet_companion_pro/presentation/providers/theme_provider.dart';
import 'package:ai_pet_companion_pro/routing/app_router.dart';
import 'package:ai_pet_companion_pro/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        localDataSourceProvider
            .overrideWithValue(storageService.dataSource),
      ],
      child: const AIPetCompanionProApp(),
    ),
  );
}

final _appRouter = AppRouter();

class AIPetCompanionProApp extends ConsumerWidget {
  const AIPetCompanionProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'AI Pet Companion Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _appRouter.router,
      builder: (context, child) {
        return AnimatedTheme(
          data: themeMode == ThemeMode.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          duration: const Duration(milliseconds: 300),
          child: _AppBuilder(child: child),
        );
      },
    );
  }
}

class _AppBuilder extends StatelessWidget {
  final Widget? child;

  const _AppBuilder({this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling,
      ),
      child: Stack(
        children: [
          if (child != null) child!,
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorConstants.primary,
                      ColorConstants.secondary,
                      ColorConstants.primary,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
