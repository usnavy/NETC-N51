import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:train_trax/utils/urls.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:train_trax/utils/APICall.dart';
import 'package:train_trax/utils/urls.dart';

import '../../widgets/Navigation.dart';

class OurLibrary extends StatelessWidget {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');
  final fieldText = TextEditingController();
  String currentPage = "LIBRARY";
  var _hover = false;
  String name = 'John Smith';
  String token;
  List articles;
  List allArticles;
  bool isAdmin = false;

  OurLibrary(
      {Key? key,
      required this.token,
      required this.articles,
      required this.name,
      required this.isAdmin,
      required this.allArticles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    articles.shuffle();
    int len = articles.length;
    if (len > 10) {
      len = 10;
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                TopBar.createTopBar(context, name, currentPage, token, isAdmin),
                //Logo
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image.asset(
                    "assets/NETC_Logo.jpg",
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Page bar
                NavBar.createNavBar(context, currentPage, token, name, isAdmin),

                //Library Search
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "LIBRARY SEARCH",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                //Search bar
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black)),
                  child: Center(
                    child: TextField(
                      controller: fieldText,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              /* Clear the search field */
                              fieldText.clear();
                            },
                          ),
                          hintText: 'Search...',
                          border: InputBorder.none),
                      onSubmitted: (value) async {
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
                                                    if (allArticles.contains(
                                                        fieldText.text))
                                                      TextSpan(
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        text: fieldText.text +
                                                            " is in the database",
                                                      ),
                                                    if (!allArticles.contains(
                                                        fieldText.text))
                                                      TextSpan(
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        text: fieldText.text +
                                                            " is not the database",
                                                      ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        if (allArticles
                                            .contains(fieldText.text))
                                          RaisedButton(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 100),
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
                                              APICall.addArticleRequest(
                                                  token, fieldText.text);
                                              Navigator.pop(context);
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                //Recommmended list
                Container(
                  child: Text(
                    "RECOMMENDED",
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                for (var i = 0; i < len; i++)
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
                                  fontWeight: FontWeight.normal,
                                ),
                                text: "",
                              ),
                              TextSpan(
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
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
                                          builder: (BuildContext context) =>
                                              Dialog(
                                                child: Center(
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            15.0),
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 6 * 24,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  Urls.createUrl(
                                                                      url: articles[
                                                                          i],
                                                                      txt: articles[
                                                                          i],
                                                                      context:
                                                                          context),
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                      Wrap(
                                                        spacing: 20.0,
                                                        children: [
                                                          RaisedButton(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          100),
                                                              child: Text(
                                                                "Add",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              APICall
                                                                  .addArticleRequest(
                                                                      token,
                                                                      articles[
                                                                          i]);
                                                            },
                                                          ),
                                                          // RaisedButton(
                                                          //   child: Padding(
                                                          //     padding: EdgeInsets.symmetric(horizontal: 100),
                                                          //     child: Text(
                                                          //       "Favorite",
                                                          //       style: TextStyle(
                                                          //         color: Colors.white,
                                                          //         fontWeight: FontWeight.bold,
                                                          //         fontSize: 20.0,
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          //   onPressed: () {
                                                          //     //delete[i] = true;
                                                          //     //Navigator.pop(context, delete);
                                                          //     //APICall.addFavoriteRequest(token, articleid);
                                                          //   },
                                                          // ),

                                                          // RaisedButton(
                                                          //   child: Padding(
                                                          //     padding: EdgeInsets.symmetric(horizontal: 100),
                                                          //     child: Text(
                                                          //       "Download",
                                                          //       style: TextStyle(
                                                          //         color: Colors.white,
                                                          //         fontWeight: FontWeight.bold,
                                                          //         fontSize: 20.0,
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          //   onPressed: () {
                                                          //     //delete[i] = false;
                                                          //     //Navigator.pop(context, delete);
                                                          //     //APICall.addDownloadRequest(token, articleid);
                                                          //   },
                                                          // )
                                                          //if(delete)
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
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
