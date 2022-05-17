import 'dart:convert';
import 'package:http/http.dart';
import 'package:train_trax/screens/home/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:train_trax/screens/login/login.dart';
import 'package:train_trax/utils/APICall.dart';

class OurSettingsForm extends StatelessWidget {
  String token;
  String name;
  bool isAdmin = false;
  String email = '';

  OurSettingsForm(
      {Key? key,
      required this.token,
      required this.name,
      required this.isAdmin,
      required this.email})
      : super(key: key);

  void _changePassword({
    required String token,
    required String password,
    required String passwordConfirm,
    required BuildContext context,
  }) async {
    try {
      String _returnString;
      if (password == passwordConfirm) {
        _returnString = await APICall.resetPasswordRequest(token, password);
        Response token2 =
            await APICall.getStarredArticleRequest(token) as Response;
        var resultList = jsonDecode(token2.body);
        Response userStat = await APICall.getUserStats(token) as Response;
        var stats = jsonDecode(userStat.body);
        List startedArticles =
            (await APICall.getStartedArticleRequest(token)) as List;
        List completedArticles =
            (await APICall.getCompleteArticleRequest(token)) as List;

        if (_returnString == "success") {
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              "SETTINGS",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text("User Information:"),
          const SizedBox(
            height: 5.0,
          ),

          //Email
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '   Email:  ',
                ),
                TextSpan(
                  text: email,
                ),
              ],
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),

          const SizedBox(
            height: 20.0,
          ),

          //Change Password
          Text("Change Password?"),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.password), hintText: "New Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordConfirmController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.password),
                hintText: "Confirm New Password"),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: RaisedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {
                _changePassword(
                    token: token,
                    password: _passwordController.text,
                    passwordConfirm: _passwordConfirmController.text,
                    context: context);
              },
            ),
          ),

          SizedBox(
            height: 20.0,
          ),

          //sign out button
          Center(
            child: RaisedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OurLogin(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
