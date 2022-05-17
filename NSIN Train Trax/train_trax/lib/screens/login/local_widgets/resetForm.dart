import 'package:train_trax/widgets/shadowContainer.dart';
import 'package:train_trax/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:train_trax/utils/APICall.dart';

enum LoginType {
  email,
  google,
}
void _resetPassword({
  required String token,
  required String password,
  required String passwordConfirm,
  required BuildContext context,
}) async {
  try {
    String _returnString;
    if (password == passwordConfirm) {
      _returnString = await APICall.resetPasswordRequest(token, password);

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurLogin(),
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
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords are not the same"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

TextEditingController _tokenController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _passwordConfirmController = TextEditingController();

class OurResetPasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Reset Password",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _tokenController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.star), hintText: "Verification code"),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline), hintText: "New Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordConfirmController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Confirm New Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Reset",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              _resetPassword(
                  token: _tokenController.text,
                  password: _passwordController.text,
                  passwordConfirm: _passwordConfirmController.text,
                  context: context);
            },
          ),
        ],
      ),
    );
  }
}
