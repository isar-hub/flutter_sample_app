import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
