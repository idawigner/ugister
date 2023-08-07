// ignore_for_file: prefer_typing_uninitialized_variables, unused_field

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'signup_screen.dart';
import 'success_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _err;
  var _user;
  bool _isErr = false;
  bool showSpinner = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future SignIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isErr = false;
        showSpinner = true;
      });
      try {
        final user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        _user = user;
        setState(() {
          showSpinner = false;
        });
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SuccessScreen()),
          );
        });
      } on FirebaseAuthException catch (e) {
        _isErr = true;
        _err = e.code;
        print('Error while signing in: $_err');
      }
      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          setState(() {
            _user = userCredential.user; // Update the _user variable
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SuccessScreen()),
          );
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    double screenWidth = MediaQuery.of(context).size.width;
    // GoogleSignInAccount? user = _currentuser;
    return Scaffold(
        body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Center(
                child: SizedBox(
              width: screenWidth,
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: screenWidth * 0.15, right: 20, top: 35),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  padding: const EdgeInsets.only(right: 20),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.teal,
                                  )),
                              if (!isKeyboard)
                                SvgPicture.asset(
                                  'images/login.svg',
                                  width: 175,
                                  height: 125,
                                )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Please SignIn to Continue',
                          style: TextStyle(
                            color: Color(0xFFD8D8D8),
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 25),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 59,
                          width: screenWidth * 0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xFF524563),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 20),
                                  blurRadius: 100,
                                  color: Color(0x374B4268)),
                            ],
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Color(0xFFD8D8D8)),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.teal,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.email_outlined,
                                color: Colors.teal,
                              ),
                              hintText: "Enter Email",
                              hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Field empty!";
                              } else if (!EmailValidator.validate(v)) {
                                return "Invalid Email!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 25),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 59,
                          width: screenWidth * 0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xFF524563),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 20),
                                  blurRadius: 100,
                                  color: Color(0x374B4268)),
                            ],
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Color(0xFFD8D8D8)),
                            controller: _passwordController,
                            obscureText: true,
                            cursorColor: Colors.teal,
                            decoration: const InputDecoration(
                              focusColor: Colors.teal,
                              icon: Icon(
                                Icons.vpn_key_outlined,
                                color: Colors.teal,
                              ),
                              hintText: "Enter Password",
                              hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Field Empty!";
                              } else if (v.length < 8) {
                                return "Password should be atleast 8 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final currentContext =
                                context; // Capture the context
                            FocusManager.instance.primaryFocus?.unfocus();
                            SignIn(_emailController.text,
                                    _passwordController.text)
                                .then((result) {
                              if (_isErr) {
                                showDialog(
                                  context:
                                      currentContext, // Use the captured context here
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Error! $_err',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }).catchError((error) {
                              // Handle the error if needed
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            height: 52,
                            width: screenWidth * 0.45,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [(Colors.teal), Color(0xFF00D6BD)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0x374B4268)),
                              ],
                            ),
                            child: const Text(
                              "SIGN IN",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.2,
                              right: screenWidth * 0.2),
                          child: const Row(
                            children: [
                              Expanded(
                                  child: Divider(color: Color(0xFFD8D8D8))),
                              Text(
                                '  OR  ',
                                style: TextStyle(color: Color(0xFFD8D8D8)),
                              ),
                              Expanded(
                                  child: Divider(color: Color(0xFFD8D8D8))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SignInButton(
                          Buttons.Google,
                          onPressed: signInWithGoogle,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't Have Any Account?  ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 193, 191, 191),
                                ),
                              ),
                              GestureDetector(
                                child: const Text(
                                  "Signup Now",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ))));
  }
}
