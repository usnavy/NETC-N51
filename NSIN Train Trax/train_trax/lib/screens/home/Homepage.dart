import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:train_trax/utils/APICall.dart';
import 'package:train_trax/utils/ProfileBar.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:train_trax/utils/urls.dart';
import 'package:flutter/gestures.dart';
import 'package:pspdfkit_flutter/src/main.dart';
import 'package:path_provider/path_provider.dart';

class OurHome extends StatelessWidget {
  String currentPage = "HOME";
  String name = 'John Smith';
  String token;
  var searches;
  var names;
  var toBeComplete;
  var namestoBe;
  var recommended;
  var namesRecommended;
  bool isAdmin;
  List articles;
  var userStats;
  List startedArticles;
  List completedArticles;

  OurHome({Key? key, required this.token, required this.name, required this.isAdmin, required this.articles, required this.userStats, required this.startedArticles, required this.completedArticles})
      : super(key: key);

  double progress = 0;
  static const List<String> supportedFileExtensions = ['.pdf', '.txt', '.md', '.rtf'];

  // This method uses Dio to download a file from the given URL
  // and saves the file to the provided `savePath`.
  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      var file = File(savePath).openSync(mode: FileMode.write);
      file.writeFromSync(response.data);
      await file.close();

      // Here, you're catching an error and printing it. For production
      // apps, you should display the warning to the user and give them a
      // way to restart the download.
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    int len = articles.length;
    int leng = startedArticles.length;
    int lengt = completedArticles.length;

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                TopBar.createTopBar(context, name, currentPage, token, isAdmin),

                //Logo
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    "assets/NETC_Logo.jpg",
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),

                NavBar.createNavBar(context, currentPage, token, name, isAdmin),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "USER DASHBOARD",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Total Articles Started: " + userStats["total_articles_started"].toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Average Articles Started: " + userStats["average_articles_started"].toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Average Articles Completed: " + userStats["average_articles_completed"].toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Total Articles Completed: " + userStats["total_articles_completed"].toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "RECOMMENDED",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                for (var i = 0; i < 5; i++)
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                text: "",
                              ),
                              TextSpan(
                                  style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                  ),
                                  //name of article
                                  text: articles[i],
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => Dialog(
                                                child: Center(
                                                  child: Wrap(
                                                    alignment: WrapAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(15.0),
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            height: 6 * 24,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  Urls.createUrl(url: articles[i], txt: articles[i], context: context),
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                      Wrap(
                                                        spacing: 20.0,
                                                        children: [
                                                          RaisedButton(
                                                            child: const Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 100),
                                                              child: Text(
                                                                "Add",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              APICall.addArticleRequest(token, articles[i]);
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "STARTED CONTENT",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                for (var i = 0; i < leng; i++)
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                text: "",
                              ),
                              TextSpan(
                                  style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                  ),
                                  //name of article

                                  text: startedArticles[i]["article"],
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      String imageUrl = startedArticles[i]["article"].toString();

                                      bool safe = false;
                                      for (String ext in supportedFileExtensions) {
                                        if (imageUrl.endsWith(ext)) {
                                          safe = true;
                                          break;
                                        }
                                      }

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => Dialog(
                                                child: Center(
                                                  child: Wrap(
                                                    alignment: WrapAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(15.0),
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            height: 6 * 24,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  Urls.createUrl(url: startedArticles[i]["article"], txt: startedArticles[i]["article"], context: context),
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                      Wrap(
                                                        spacing: 20.0,
                                                        children: [
                                                          RaisedButton(
                                                            child: const Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 100),
                                                              child: Text(
                                                                "Favorite",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              APICall.addFavoriteRequest(token, startedArticles[i]["article_id"].toString());
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          RaisedButton(
                                                            child: const Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 100),
                                                              child: Text(
                                                                "Download",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: !safe
                                                                ? null
                                                                : () async {
                                                                    Directory? tempDir = await getExternalStorageDirectory();
                                                                    if (tempDir != null) {
                                                                      String fileName = imageUrl.contains('/') ? imageUrl.substring(imageUrl.lastIndexOf('/') + 1) : imageUrl;
                                                                      download(Dio(), imageUrl, tempDir.path + '/' + fileName);
                                                                      print(tempDir.path);
                                                                    }
                                                                  },
                                                          ),
                                                          RaisedButton(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 100),
                                                              child: Text(
                                                                "Mark as Completed",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              APICall.setEndTimeRequest(token, startedArticles[i]["article_id"].toString());
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "COMPLETED CONTENT",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                for (var i = 0; i < lengt; i++)
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                text: "",
                              ),
                              TextSpan(
                                  style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                  ),
                                  //name of article

                                  text: completedArticles[i]["article"],
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => Dialog(
                                                child: Center(
                                                  child: Wrap(
                                                    alignment: WrapAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(15.0),
                                                        child: Container(
                                                            alignment: Alignment.center,
                                                            height: 6 * 24,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  Urls.createUrl(url: completedArticles[i]["articles"], txt: completedArticles[i]["articles"], context: context),
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                      Wrap(
                                                        spacing: 20.0,
                                                        children: [
                                                          RaisedButton(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 100),
                                                              child: Text(
                                                                "Favorite",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          RaisedButton(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 100),
                                                              child: Text(
                                                                "Download",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
