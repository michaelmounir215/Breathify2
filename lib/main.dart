import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cwzewtpnacschxszskps.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN3emV3dHBuYWNzY2h4c3pza3BzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3NjkzMjYsImV4cCI6MjA2MjM0NTMyNn0.DnWwRYip8dIGcdhcLqqVoitEgw-EnQ3_suV01d_ZVMA',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Breathify',
        theme: ThemeData(
          fontFamily: 'LeagueSpartan', // Apply font globally
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            headlineSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            bodyMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}