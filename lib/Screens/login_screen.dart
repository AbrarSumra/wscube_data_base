// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_data_base/AppData/app_data.dart';
import 'package:wscube_data_base/Screens/sign_up_screen.dart';

import '../widgets/custom_elevated_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String LOGIN_PREF_KEY = "isLogin";
  static const String USERNAME_PREF_KEY = "uName";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Login Screen BackGround Image.avif"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 150, left: 30),
                height: 270,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedTextKit(
                      repeatForever: true,
                      isRepeatingAnimation: true,
                      animatedTexts: [
                        WavyAnimatedText(
                          "Welcome",
                          textStyle: GoogleFonts.habibi(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Back",
                          speed: const Duration(milliseconds: 250),
                          textStyle: GoogleFonts.damion(
                            fontSize: 35,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: ((value) {
                        if (value!.isEmpty) return "Please Enter Username";
                        return null;
                      }),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade50,
                        filled: true,
                        hintText: "Enter UserName",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passController,
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 8) {
                          return "Please Enter Atleast 8 Characters Password";
                        }
                        return null;
                      }),
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade50,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Enter Password",
                        suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: () async {
                          if (emailController.text.isNotEmpty &&
                              passController.text.isNotEmpty) {
                            var email = emailController.text.toString();
                            var pass = passController.text.toString();

                            var appData = AppDataBase.instance;
                            if (await appData.authenticate(email, pass)) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => const HomeScreen()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Invalid Email and Password!!!")));
                            }
                          }

                          var prefs = await SharedPreferences.getInstance();
                          prefs.setBool(LoginScreen.LOGIN_PREF_KEY, true);

                          var name = emailController.text.toString();
                          prefs.setString(LoginScreen.USERNAME_PREF_KEY, name);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.indigo),
                            )),
                        const Divider(
                          height: 15,
                          thickness: 2,
                          color: Colors.black,
                        ),
                        CustomElevatedButton(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => SignUpScreen()));
                          },
                          text: "Create New Account",
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
