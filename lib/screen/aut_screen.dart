// ignore_for_file: constant_identifier_names

import 'package:belanja_app/common/handling_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

enum AuthMode { Login, Signup }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
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
        ]),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  // ignore: prefer_final_fields
  Map<String, dynamic> _authData = {'email': '', 'password': ''};

  var _isLoading = false;
  final passwordController = TextEditingController();
  // controller animation
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
          parent: _controller!, curve: Curves.fastLinearToSlowEaseIn),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));
    // _controller!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terjadi kesalahan!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Oke'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid !
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .sigup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Email ini sudah digunakan.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Masukkan Email yang benar!';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Password minimal 5 karakter.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Tidak ada nama pengguna dengan email ini!.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Password salah!.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Terjadi kesalahan. Coba lagi!.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuth() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;

    return Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 320 : 260,
          constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.Signup ? 320 : 260,
          ),
          width: device.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Email salah';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Password minimal terdiri dari 5 karakter!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    // if (_authMode == AuthMode.Signup)
                    AnimatedContainer(
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 160 : 0,
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: _opacityAnimation!,
                        child: SlideTransition(
                          position: _slideAnimation!,
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Confirm password'),
                              obscureText: true,
                              enabled: _authMode == AuthMode.Signup,
                              validator: _authMode == AuthMode.Signup
                                  ? (value) {
                                      if (value != passwordController.text) {
                                        return 'Kata sandi tidak cocok!';
                                      }
                                      return null;
                                    }
                                  : null),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30.0),
                            primary: Theme.of(context).primaryColor),
                      ),
                    TextButton(
                      onPressed: _switchAuth,
                      child: Text(
                        "${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} ",
                      ),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          primary: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              )),
        ));
  }
}
