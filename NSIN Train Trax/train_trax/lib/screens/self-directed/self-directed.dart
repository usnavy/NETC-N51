import 'package:flutter/material.dart';
import 'package:train_trax/utils/APICall.dart';
import 'package:train_trax/utils/urls.dart';
import 'package:train_trax/utils/ProfileBar.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class OurSelfDirected extends StatelessWidget {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');
  final fieldText = TextEditingController();
  String currentPage = "SELF-DIRECTED";
  String name = 'John Smith';
  String token;
  bool isAdmin = false;
  List articles;

  OurSelfDirected(
      {Key? key,
      required this.token,
      required this.name,
      required this.isAdmin,
      required this.articles})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    int len = articles.length;

    return Scaffold(
      body: Row(
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

                //Search
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "SEARCH ONLINE",
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
                        await launch(
                            "http://www.google.com/search?q=" + fieldText.text);
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),
                Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).secondaryHeaderColor),
                        ),
                        onPressed: () {
                          launch(fieldText.text);
                        },
                        child: const Text('Search'),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).secondaryHeaderColor),
                        ),
                        onPressed: () {
                          launch("http://www.google.com/search?q=" +
                              fieldText.text);
                        },
                        child: const Text('Search Google'),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).secondaryHeaderColor),
                        ),
                        onPressed: () {
                          APICall.addArticleRequest(token, fieldText.text);
                          fieldText.clear();
                        },
                        child: const Text('Add'),
                      ),
                    ])),

                //MY ARTICLES
                Container(
                  child: Text(
                    "MY ARTICLES",
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
                                text: "\u2022 ",
                              ),
                              Urls.createUrl(
                                  url: articles[i]["article"],
                                  txt: articles[i]["article"],
                                  context: context),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
