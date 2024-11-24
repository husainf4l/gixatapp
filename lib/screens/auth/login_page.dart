import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gixatapp/components/my_button.dart';
import 'package:gixatapp/components/my_textfield.dart';
import 'package:gixatapp/components/square_tile.dart';
import 'dart:io';

import 'package:gixatapp/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: CupertinoColors.lightBackgroundGray,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const Icon(
                      Icons.lock,
                      size: 70,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 30),

                    // Login Form Card
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          MyTextField(
                            controller: emailController,
                            hintText: 'Enter your email',
                            obscureText: false,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints:
                                AutofillHints.email, // Enable email autofill
                          ),

                          const SizedBox(height: 10),

                          // Password TextField
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Enter your password',
                            obscureText: true,
                            prefixIcon: Icons.lock,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: AutofillHints.password,
                          ),

                          const SizedBox(height: 10),

                          // Sign-In Button
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: MyButton(
                              onTap: () {
                                authController.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              },
                              title: "Sign In",
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.snackbar(
                                    "Forgot Password",
                                    "Feature not implemented yet.",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // OR Divider
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Social Media Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                          onTap: () {
                            authController.signInWithGoogle();
                          },
                          imagePath: 'assets/images/google.png',
                        ),
                        const SizedBox(width: 20),
                        if (!Platform
                            .isAndroid) // Show Apple login only if it's not Android
                          SquareTile(
                            onTap: () {
                              authController.signInWithApple();
                            },
                            imagePath: 'assets/images/apple.png',
                          ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Register Now
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
