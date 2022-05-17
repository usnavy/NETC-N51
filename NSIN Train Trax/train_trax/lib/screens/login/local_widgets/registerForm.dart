import 'package:train_trax/widgets/shadowContainer.dart';
import 'package:train_trax/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:train_trax/utils/APICall.dart';

enum LoginType {
  email,
  google,
}

class OurRegisterForm extends StatelessWidget {

  void _registerUser({
    required String email,
    required String password,
    required String phone,
    required String passwordConfirm,
    required String first,
    required String last,
    required BuildContext context,
  }) async {
    try {
      String name = first + " " + last;
      String _returnString;
      if(password == passwordConfirm){
        _returnString = await APICall.registerRequest( email, password, phone, name);
          
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

      }
      else{
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

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Register",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //First Name
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person), hintText: "First Name"),
          ),
          SizedBox(
            height: 20.0,
          ),
          //Last Name
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person), hintText: "Last Name"),
          ),
          SizedBox(
            height: 20.0,
          ),
          //Phone Number
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.call), hintText: "Phone Number"),
          ),
          SizedBox(
            height: 20.0,
          ),
          //Email
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email), hintText: "Email"),
          ),
          SizedBox(
            height: 20.0,
          ),
          //Password
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline), hintText: "Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          //Confirm Password
          TextFormField(
            controller: _passwordConfirmController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Confirm Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          //Register Button
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              _registerUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                  passwordConfirm: _passwordConfirmController.text, 
                  context: context, 
                  first: _firstNameController.text, 
                  last: _lastNameController.text, 
                  phone: _phoneController.text);
            },
          ),
        ],
      ),
    );
  }
}
