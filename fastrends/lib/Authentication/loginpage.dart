// ignore: file_names
import 'package:fastrends/Authentication/MyTextField.dart';
import 'package:fastrends/Authentication/my_button.dart';
import 'package:fastrends/Authentication/signuppage.dart';
import 'package:fastrends/Main_Pages/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fastrends/config.dart';

//one language option
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void wrongEmailMessage(String s) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(s),
          );
        });
  }

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: usernameController.text, password: passwordController.text)
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
      );
    }).onError((error, StackTrace) {
      wrongEmailMessage(error.toString().split("]").elementAt(1).trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final String languageOption = 'ta';
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                const SizedBox(
                  height: 40,
                ),
                Image(image: AssetImage("assets/images/Logo.png")),
                Text(
                  Config.welcomebackUserYouveBeenMissed[languageOption]!,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: usernameController,
                  hintText: Config.username[languageOption]!,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: Config.password[languageOption]!,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text(
                          Config.signupInstead[languageOption]!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => SignUpPage(),
                                  transitionDuration:
                                      Duration(milliseconds: 0)));
                        },
                      ),
                      Text(
                        Config.forgotpassword[languageOption]!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                MyButton(
                  onTap: signUserIn,
                  buttonname: "sign in",
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            Config.orcontinuewith[languageOption]!,
                            style: TextStyle(color: Colors.grey[700]),
                          )),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Container(
                  width: 350,
                  height: 70,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200]),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                        ),
                        Image.asset(
                          "assets/images/googleicon.png",
                          height: 30,
                        ),
                        Text(
                          Config.signinWithgoogle[languageOption]!,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ));
  }
}
