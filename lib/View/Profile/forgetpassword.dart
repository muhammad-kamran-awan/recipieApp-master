import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/Global%20Styles/TextFiles.dart';
import 'package:recipeapp/Responsive/Responsiveclass.dart';
import 'package:recipeapp/View/Widgets/CustomAddTextField.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeadingText(
                center: true,
                context: context,
                text: 'Hey!! Forget Your Password,',
                color: Colors.black),
            MediumlargeText(
                context: context,
                center: true,
                text: 'No Problem Its Super Easy',
                color: Colors.black),
            MediumText(
                center: true,
                context: context,
                text: "Just See the Magic",
                color: Colors.grey),
            SizedBox(
              height: 50,
            ),
            Text(
              "Please Enter Your Email",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: TextFormField(
                validator: (value) {
                  if (value!.contains('@gmail.com')) {
                    return null;
                  } else {
                    setState(() {});
                    return 'Please write valid email';
                  }
                },
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter Your Email Title",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 15,
            ),

            InkWell(
              onTap: () async {
                if (emailController.text != null &&
                    emailController.text.isNotEmpty) {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);
                    // Show a success message to the user and navigate them back to the login screen.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Password reset email sent. Check your inbox.'),
                      ),
                    );
                    Navigator.pop(
                        context); // Navigate back to the login screen.
                  } catch (e) {
                    // Handle errors, such as invalid email or network issues.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                      ),
                    );
                  }
                } else {
                  // Show an error message if the email field is empty.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your email.'),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    "Send Reset Link",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )

            // Inside your password reset screen widget
          ],
        ),
      ),
    );
  }
}
