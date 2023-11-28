// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image:
                AssetImage("assets/images/Login Screen BackGround Image.avif"),
            fit: BoxFit.cover),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Back",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: userName,
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
                      controller: passWord,
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
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setBool(LoginScreen.LOGIN_PREF_KEY, true);

                          var name = userName.text.toString();
                          prefs.setString(LoginScreen.USERNAME_PREF_KEY, name);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
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
                            onTap: () {}, text: "Create New Account")
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
