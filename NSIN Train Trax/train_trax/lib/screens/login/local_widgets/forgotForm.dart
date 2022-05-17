import 'package:train_trax/widgets/shadowContainer.dart';
import 'package:train_trax/screens/login/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:train_trax/utils/APICall.dart';

enum LoginType {
  email,
  google,
}

void _forgotPassword({
  required String email,
  required BuildContext context,
}) async {
  try {
    String _returnString;
    _returnString = await APICall.forgotPasswordRequest(email);

    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OurResetPassword(),
        ),
        (route) => false,
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(_returnString),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

TextEditingController _emailController = TextEditingController();

class OurForgotForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Forgot Password",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email), hintText: "Email"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Send Reset Link",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              _forgotPassword(email: _emailController.text, context: context);
            },
          ),
        ],
      ),
    );
  }
}
