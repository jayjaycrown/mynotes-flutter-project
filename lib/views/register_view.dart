// import 'dart:developer' show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                      // log(userCredential.toString());
                      // log(userCredential.toString());
                      final user = FirebaseAuth.instance.currentUser;
                      await user?.sendEmailVerification();
                      if (!mounted) return;
                      Navigator.of(context).pushNamed(
                        verifyEmailRoute,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        // log('User already exists');
                        await showErrorDialog(
                          context,
                          'User already exists',
                        );
                      } else if (e.code == 'weak-password') {
                        await showErrorDialog(
                          context,
                          'Password should be at least 6 characters ',
                        );
                        // log('Password should be at least 6 characters ');
                      } else if (e.code == 'invalid-email') {
                        // log('Email is invalid');
                        await showErrorDialog(
                          context,
                          'Email is invalid',
                        );
                      } else {
                        await showErrorDialog(
                          context,
                          'Error:  $e.code',
                        );
                        // log(e.code);
                      }
                    } catch (e) {
                      await showErrorDialog(
                        context,
                        e.toString(),
                      );
                    }
                    // print(UserCredential);
                  },
                  child: const Text('Register')),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text('Already have an account?, Login here'))
          ],
        ),
      ),
    );
  }
}
