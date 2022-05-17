import 'package:flutter/material.dart';
import 'package:train_trax/utils/ProfileBar.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:train_trax/utils/APICall.dart';
import 'package:train_trax/utils/urls.dart';

class OurFavorite extends StatelessWidget {
  String currentPage = "FAVORITE";
  String name = 'John Smith';
  String token;
  List articles;
  bool isAdmin = false;

  OurFavorite(
      {Key? key,
      required this.token,
      required this.articles,
      required this.name,
      required this.isAdmin})
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
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                TopBar.createTopBar(context, name, currentPage, token, isAdmin),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "FAVORITES",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 5.0,
                    ),
                    for (var i = 0; i < len; i++)
                      Container(
                        child: Wrap(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.favorite),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () {
                                APICall.removeFavoriteRequest(token,
                                    articles[i]["article_id"].toString());
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(13),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Urls.createUrl(
                                        url: articles[i]["article"],
                                        txt: articles[i]["article"],
                                        context: context),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
