import 'package:flutter/material.dart';
import 'package:train_trax/utils/ProfileBar.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:train_trax/utils/APICall.dart';

class OurAddResources extends StatelessWidget {
  String currentPage = "ADD RESOURCES";
  String name = 'John Smith';
  String token;
  bool isAdmin = true;
  final fieldText = TextEditingController();

  OurAddResources({Key? key, required this.token, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  height: 20.0,
                ),
                //Page bar
                NavBar.createAdminNavBar(context, currentPage, token, name),

                const SizedBox(
                  height: 20.0,
                ),

                //Search
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "ADD RESOURCES",
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
                          APICall.addStarredArticleRequest(
                              token, fieldText.text);
                          fieldText.clear;
                        },
                        child: const Text('Add'),
                      ),
                    ])),
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
