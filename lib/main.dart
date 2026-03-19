import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mealtime/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Keep app runnable even when .env is missing in local preview.
  }
  runApp(const MyApp());
}
