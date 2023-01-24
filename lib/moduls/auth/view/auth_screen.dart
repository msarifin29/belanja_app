// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

enum AuthMode { Login, Signup }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 128, 128, 0).withOpacity(0.5),
                    const Color.fromARGB(255, 128, 128, 0).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 1],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: device.height,
                width: device.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 250,
                        height: 170,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: const AuthCard(),
                      flex: device.width > 600 ? 2 : 1,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
