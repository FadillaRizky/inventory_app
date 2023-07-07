
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_app/views/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              'Inventory Apps',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
            ),
            Text(
              "Login with",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                height: 65,
                width: 65,
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: IconButton(
                      onPressed: () {
                        _googleSignIn.signIn().then((value) {
                          String userName = value!.displayName!;
                          print(value.photoUrl);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        userName: userName,
                                        photoUrl: value.photoUrl!,
                                      )));
                        });
                      },
                      icon: Image.asset(
                        "assets/google_logo.png",
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
