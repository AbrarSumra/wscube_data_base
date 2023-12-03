// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wscube_data_base/AppData/app_data.dart';
import 'package:wscube_data_base/Screens/login_screen.dart';
import 'package:wscube_data_base/model/user_model.dart';
import 'package:wscube_data_base/widgets/cstm_text_field.dart';
import 'package:wscube_data_base/widgets/custom_elevated_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 21),
                const Text(
                  "Create your account",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 21),
                CustomTextField(
                  controller: nameController,
                  label: "Enter Your Name",
                  name: "Name*",
                ),
                CustomTextField(
                  controller: emailController,
                  label: "Enter Your Email",
                  name: "Email*",
                ),
                CustomTextField(
                  controller: passController,
                  label: "Enter Your Password",
                  name: "Password*",
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomElevatedButton(
                    onTap: () async {
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          passController.text.isNotEmpty) {
                        var appDb = AppDataBase.instance;

                        var checkCreate = await appDb.createAccount(UserModel(
                          user_id: 0,
                          user_name: nameController.text.toString(),
                          user_email: emailController.text.toString(),
                          user_pass: passController.text.toString(),
                        ));

                        var msg = "";

                        if (checkCreate) {
                          msg = "Account create successfully";
                        } else {
                          msg = "Can't create account as Email already exists";
                        }

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }
                    },
                    text: "Sign Up",
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const LoginScreen()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
