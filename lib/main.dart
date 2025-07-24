import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/models/model_user.dart';
import 'models/model_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:movies/views/main_login.dart';


void main() => runApp(MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create:(context) => ThemeModel()),
          ChangeNotifierProvider(create: (context) => UserModel()),
        ],
        child: const MyApp(),
      ),
      debugShowCheckedModeBanner: false,
    ));



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            // Define the default brightness and colors.
            colorScheme: ColorScheme.fromSeed(
              seedColor: Provider.of<ThemeModel>(context).seedColor,
              dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
              brightness: Provider.of<ThemeModel>(context).brightness,
            ),

            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              displayLarge: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
              // ···
              titleLarge: GoogleFonts.oswald(
                fontSize: 30,
                fontStyle: FontStyle.italic,
              ),
              bodyMedium: GoogleFonts.merriweather(),
              displaySmall: GoogleFonts.pacifico(),
            ),
          ),
          home: Login(),
        );
      },
    );
  }
}