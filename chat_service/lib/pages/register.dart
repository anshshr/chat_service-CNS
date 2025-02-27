import 'package:chat_service/Auth/auth.dart';
import 'package:chat_service/components/button.dart';
import 'package:chat_service/components/circular_indicator.dart';
import 'package:chat_service/components/dialog.dart';
import 'package:chat_service/components/textfield.dart';
import 'package:chat_service/pages/login.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  Register({super.key});
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confpassword = TextEditingController();
  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 450,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // welcome text
                const Text(
                  'Welcome 😊 😊',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                //name
                Textfield(
                  controller: username,
                  hinttext: 'Enter your username',
                  icon: Icons.person,
                  obstext: false,
                ),
                // email
                Textfield(
                  controller: email,
                  hinttext: 'Enter your Email',
                  icon: Icons.email,
                  obstext: false,
                ),
                //password
                Textfield(
                  controller: password,
                  hinttext: 'Enter your password',
                  icon: Icons.password,
                  obstext: true,
                ),
                // conform password
                Textfield(
                  controller: confpassword,
                  hinttext: 'Confirm Password',
                  icon: Icons.password,
                  obstext: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                // already have an account login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an accoount , ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // register button
                Button(
                    text: 'REGISTER',
                    ontap: () async {
                      if (email.text == '' ||
                          password.text == '' ||
                          confpassword.text == '' ||
                          username.text == '') {
                        dailog(
                          "Please Enter all the Fields",
                          context,
                          () => Navigator.pop(context),
                        );
                      } else if (password.text != confpassword.text) {
                        dailog("Passwords don't match", context,
                            () => Navigator.pop(context));
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularIndicator()),
                        );
                        final String user =
                            await auth.registerUser(email.text, password.text);
                        Navigator.pop(context);
                        if (user == "Success") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                        } else {
                          dailog(user, context, () => Navigator.pop(context));
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
