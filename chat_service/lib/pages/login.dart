import 'package:chat_service/Auth/auth.dart';
import 'package:chat_service/components/button.dart';
import 'package:chat_service/components/circular_indicator.dart';
import 'package:chat_service/components/dialog.dart';
import 'package:chat_service/components/textfield.dart';
import 'package:chat_service/pages/home.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 250,
          width: 500,
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //welcome text
              const Text(
                "Hello 😊😊 , Login Here ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              // email
              Textfield(
                  controller: email,
                  hinttext: "Enter your email",
                  icon: Icons.email,
                  obstext: false),
              //password

              Textfield(
                  controller: password,
                  hinttext: "Password",
                  icon: Icons.lock,
                  obstext: true),

              //login button

              Button(
                  text: "Login",
                  ontap: () async {
                    if (password.text == '' || email.text == '') {
                      dailog("Please Enter all the details", context,
                          () => Navigator.pop(context));
                    } else {
                         showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularIndicator()),
                        );
                      final String user =
                          await auth.loginUser(email.text, password.text);
                        Navigator.pop(context);

                      if (user == "Success") {

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                          (route) => false,
                        );
                      } else {
                        dailog(user, context, () => Navigator.pop(context));
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
