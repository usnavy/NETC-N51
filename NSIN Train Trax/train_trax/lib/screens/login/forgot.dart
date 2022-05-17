import 'package:train_trax/screens/login/local_widgets/forgotForm.dart';
import 'package:flutter/material.dart';

class OurForgot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image.asset(
                    "assets/NETC_Logo.jpg",
                    height: 250,
                    width: 250,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                OurForgotForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
