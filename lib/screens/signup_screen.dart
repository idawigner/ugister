// ignore_for_file: unused_field

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isErr = false;
  var _err;
  var _user;
  bool _showSpinner = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signUp(String email, String password) async {
    setState(() {
      _showSpinner = true;
    });
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = user;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Error'),
          content: Text(e.message ?? 'An error occurred.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isErr = false;
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
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
                        left: screenWidth * 0.15,
                        right: 20,
                        top: 35,
                      ),
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
                            ),
                          ),
                          if (!isKeyboard)
                            SvgPicture.asset(
                              'images/login.svg',
                              width: 175,
                              height: 125,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Please SignUp to Continue',
                      style: TextStyle(
                        color: Color(0xFFD8D8D8),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.teal,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person_outline_outlined,
                            color: Colors.teal,
                          ),
                          hintText: "Enter Full Name",
                          hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Field Empty!";
                          } else if (v.length < 3) {
                            return "Name too short!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                            return "Email can't be empty";
                          } else if (!EmailValidator.validate(v)) {
                            return "Email not valid";
                          } else if (_err == 'email-already-in-use') {
                            return "Email associated with another user";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                        controller: _phoneNoController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.teal,
                        decoration: const InputDecoration(
                          focusColor: Colors.teal,
                          icon: Icon(
                            Icons.phone_outlined,
                            color: Colors.teal,
                          ),
                          hintText: "Enter Phone Number",
                          hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Field Empty!";
                          } else if (v.length < 11 || v.length > 11) {
                            return "Incorrect number!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          await _signUp(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 25,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 52,
                        width: screenWidth * 0.45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.teal, Color(0xFF00D6BD)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 50,
                              color: Color(0x374B4268),
                            ),
                          ],
                        ),
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already a Member?  ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 193, 191, 191),
                            ),
                          ),
                          GestureDetector(
                            child: const Text(
                              "Login Now",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
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
