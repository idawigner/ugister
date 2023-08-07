import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_screen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late ConfettiController _controllerBottomCenter;

  GoogleSignInAccount? _currentuser;
  final _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 4));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerBottomCenter.play());
    _getCurrentUser(); // Call to get the current user
    super.initState();
  }

  // Fetch the current signed-in user
  Future<void> _getCurrentUser() async {
    final GoogleSignInAccount? user = await _googleSignIn.signInSilently();
    if (user != null) {
      setState(() {
        _currentuser = user;
      });
    }
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    GoogleSignInAccount? user = _currentuser;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              padding: EdgeInsets.only(
                  right: screenWidth * 0.6, bottom: screenWidth * 0.4),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.teal,
              )),
          ListTile(
            title: Text(user?.displayName ?? ''),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerBottomCenter,
              blastDirection: pi / 2,
              maxBlastForce: 3,
              minBlastForce: 2,
              emissionFrequency: 0.3,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(20, 20),
              numberOfParticles: 1,
              gravity: 1,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Congratulations,',
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                  fontSize: 27),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'You have logged in.',
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w400,
                  fontSize: 22),
            ),
          ),
          SizedBox(
              height: 200,
              width: 200,
              child: SvgPicture.asset('images/success.svg')),
          GestureDetector(
            onTap: () {
              _googleSignIn.disconnect();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                "LOG OUT",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
