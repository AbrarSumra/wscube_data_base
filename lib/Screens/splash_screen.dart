// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () async {
      var prefs = await SharedPreferences.getInstance();
      bool? checkLogin = prefs.getBool(LoginScreen.LOGIN_PREF_KEY);
      Widget navigateTo = const LoginScreen();

      if (checkLogin != null && checkLogin) {
        navigateTo = const HomeScreen();
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => navigateTo));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextLiquidFill(
              boxWidth: 300,
              boxHeight: 130,
              text: "Welcome",
              textStyle: GoogleFonts.habibi(
                fontSize: 60,
                color: Colors.blue,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
