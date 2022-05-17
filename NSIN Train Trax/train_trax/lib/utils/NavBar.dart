import 'dart:convert';
import 'package:http/http.dart';
import 'package:train_trax/screens/home/Homepage.dart';
import 'package:train_trax/screens/library/library.dart';
import 'package:train_trax/screens/self-directed/self-directed.dart';
import 'package:train_trax/widgets/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:train_trax/screens/admin/adminFAQ.dart';
import 'package:train_trax/screens/admin/adminTeamMang.dart';
import 'package:train_trax/screens/home/admin/team_statistics.dart';
import 'package:train_trax/screens/home/admin/add_resources.dart';
import 'package:train_trax/utils/APICall.dart';

class NavBar {
  String? currentPage = null;
  void setPage(String? current) {
    currentPage = current;
  }

  static Navigation createNavBar(BuildContext context, String currentPage,
      String tokn, String name, bool isAdmin) {
    return Navigation(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          //HOME
          if (currentPage == "HOME")
            FlatButton(
              textColor: Colors.yellow,
              child: Text("HOME"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
            ),
          if (currentPage != "HOME")
            FlatButton(
              textColor: Colors.white,
              child: Text("HOME"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                _toHome(
                    tokn: tokn, name: name, context: context, isAdmin: isAdmin);
              },
            ),

          //LIBRARY
          if (currentPage == "LIBRARY")
            FlatButton(
              textColor: Colors.yellow,
              child: Text("LIBRARY"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
            ),
          if (currentPage != "LIBRARY")
            FlatButton(
              textColor: Colors.white,
              child: Text("LIBRARY"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                _toLibrary(
                    context: context, tokn: tokn, name: name, isAdmin: isAdmin);
              },
            ),

          //SELF-DIRECTED
          if (currentPage == "SELF-DIRECTED")
            FlatButton(
              textColor: Colors.yellow,
              child: Text("SELF-DIRECTED"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
            ),
          if (currentPage != "SELF-DIRECTED")
            FlatButton(
              textColor: Colors.white,
              child: Text("SELF-DIRECTED"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                _toSelfDirect(
                    context: context, tokn: tokn, name: name, isAdmin: isAdmin);
              },
            ),
        ],
      ),
    );
  }

  static Navigation createAdminNavBar(
      BuildContext context, String currentPage, String tokn, String name) {
    return Navigation(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          //HOME
          if (currentPage == "MANAGE_TEAMS")
            FlatButton(
              textColor: Colors.yellow,
              child: Text("MANAGE TEAMS"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
            ),
          if (currentPage != "MANAGE_TEAMS")
            FlatButton(
                textColor: Colors.white,
                child: Text("MANAGE TEAMS"),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  _toManageTeams(context: context, name: name, tokn: tokn);
                }),

          //LIBRARY
          if (currentPage == "TEAM STATS")
            FlatButton(
              textColor: Colors.yellow,
              child: Text("TEAM STATS"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
            ),
          if (currentPage != "TEAM STATS")
            FlatButton(
              textColor: Colors.white,
              child: Text("TEAM STATS"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                _toTeamStats(tokn: tokn, name: name, context: context);
              },
            ),

          //ADD RESOURCES
          if (currentPage == "ADD RESOURCES")
            FlatButton(
              textColor: Colors.yellow,
              child: Text("ADD RESOURCES"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
            ),
          if (currentPage != "ADD RESOURCES")
            FlatButton(
              textColor: Colors.white,
              child: Text("ADD RESOURCES"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OurAddResources(
                      token: tokn,
                      name: name,
                    ),
                  ),
                );
              },
            ),

          //ADMIN FAQ
          if (currentPage == "ADMIN FAQ")
            FlatButton(
              textColor: Colors.yellow,
              child: Text("ADMIN FAQ"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
            ),
          if (currentPage != "ADMIN FAQ")
            FlatButton(
              textColor: Colors.white,
              child: Text("ADMIN FAQ"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                _toAdminFAQ(tokn: tokn, name: name, context: context);
              },
            ),
        ],
      ),
    );
  }

  static void _toHome({
    required String tokn,
    required String name,
    required BuildContext context,
    required bool isAdmin,
  }) async {
    try {
      Response _returnString;
      var token;

      _returnString =
          (await APICall.getStarredArticleRequest(tokn)) as Response;
      token = jsonDecode(_returnString.body);
      Response userStat = await APICall.getUserStats(tokn) as Response;
      var stats = jsonDecode(userStat.body);
      List startedArticles =
          (await APICall.getStartedArticleRequest(tokn)) as List;
      List completedArticles =
          (await APICall.getCompleteArticleRequest(tokn)) as List;

      if (_returnString.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurHome(
                token: tokn,
                name: name,
                isAdmin: isAdmin,
                articles: token["results"],
                userStats: stats["stats"],
                startedArticles: startedArticles,
                completedArticles: completedArticles),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(token["message"]),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static void _toLibrary({
    required String tokn,
    required String name,
    required BuildContext context,
    required bool isAdmin,
  }) async {
    try {
      Response _returnString;
      List allArticles;
      var token;

      _returnString =
          (await APICall.getStarredArticleRequest(tokn)) as Response;
      allArticles = (await APICall.getAllArticleRequest(tokn)) as List;
      token = jsonDecode(_returnString.body);

      if (_returnString.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurLibrary(
              token: tokn,
              articles: token["results"],
              name: name,
              isAdmin: isAdmin,
              allArticles: allArticles,
            ),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(token["message"]),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static void _toSelfDirect({
    required String tokn,
    required String name,
    required BuildContext context,
    required bool isAdmin,
  }) async {
    try {
      List _returnString;
      var token;

      _returnString = (await APICall.getArticleRequest(tokn)) as List;

      if (_returnString != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurSelfDirected(
              token: tokn,
              articles: _returnString,
              name: name,
              isAdmin: isAdmin,
            ),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(token["message"]),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static void _toManageTeams({
    required String tokn,
    required String name,
    required BuildContext context,
  }) async {
    try {
      Response _returnString;
      var token;

      _returnString = (await APICall.getUserInfo(tokn)) as Response;
      token = jsonDecode(_returnString.body);
      //Response _returnTeam = (await APICall.getTeamInfoRequest(tokn, token["teams_admin"][0]["team_id"].toString())) as Response;

      if (_returnString.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurAdminTeamMang(
              token: tokn,
              name: name,
              listOfTeams: token["teams_admin"],
            ),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(token.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static void _toTeamStats({
    required String tokn,
    required String name,
    required BuildContext context,
  }) async {
    try {
      Response _returnString;
      var token;

      _returnString = (await APICall.getUserInfo(tokn)) as Response;
      token = jsonDecode(_returnString.body);
      Response _userStats = (await APICall.getUserStats(tokn)) as Response;
      var userstats = jsonDecode(_userStats.body);

      if (_returnString.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurTeamStatistics(
                token: tokn, name: name, teamStats: userstats),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(token["message"]),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static void _toAddResources({
    required String tokn,
    required String name,
    required BuildContext context,
  }) async {
    try {
      Response _returnString;
      var token;

      _returnString =
          (await APICall.getStarredArticleRequest(tokn)) as Response;
      token = jsonDecode(_returnString.body);

      if (_returnString.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurAddResources(
              token: tokn,
              name: name,
            ),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(token["message"]),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static void _toAdminFAQ({
    required String tokn,
    required String name,
    required BuildContext context,
  }) async {
    try {
      Response _returnList;

      _returnList = (await APICall.getQuestionsAnswerRequest(tokn) as Response);
      var listOfQ = jsonDecode(_returnList.body);

      if (_returnList != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurAdminFAQ(
              token: tokn,
              name: name,
              listOfQ: listOfQ["questions"],
            ),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("failed to load questions"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
