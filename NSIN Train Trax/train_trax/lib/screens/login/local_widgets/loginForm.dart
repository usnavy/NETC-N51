// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:train_trax/widgets/shadowContainer.dart';
import 'package:train_trax/screens/login/forgot.dart';
import 'package:train_trax/screens/login/register.dart';
import 'package:train_trax/screens/home/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:train_trax/utils/APICall.dart';

class OurLoginForm extends StatelessWidget {
  late List data;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      String _returnString;
      String token;
      
      Response _returnStringName;
      _returnString = await APICall.loginRequest(email, password);
      token = await APICall.loginTokenRequest(email, password);
     
      if (_returnString == "success") {
      _returnStringName = await APICall.getUserInfo(token);
      var nameTk = json.decode(_returnStringName.body);
      var name = nameTk["name"];
      var isAdmin = nameTk["administrator"];
      Response token2 =
          await APICall.getStarredArticleRequest(token) as Response;
      var resultList = jsonDecode(token2.body);
      Response userStat = await APICall.getUserStats(token) as Response;
      var stats = jsonDecode(userStat.body);
      List startedArticles =
          (await APICall.getStartedArticleRequest(token)) as List;
      List completedArticles =
          (await APICall.getCompleteArticleRequest(token)) as List;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurHome(
              token: token,
              name: name,
              isAdmin: isAdmin,
              articles: resultList["results"],
              userStats: stats["stats"],
              startedArticles: startedArticles,
              completedArticles: completedArticles,
            ),
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

  @override
  Widget build(BuildContext context) {
    bool check = false;
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Login",
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
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline), hintText: "Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Log in",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              _loginUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context);
            },
          ),
          FlatButton(
            child: Text("Don't have an account? Sign up here"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurRegister(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text("Forgot Password"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurForgot(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
