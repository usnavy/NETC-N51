import 'package:flutter/material.dart';
import 'package:train_trax/utils/APICall.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';

class OurFAQ extends StatelessWidget {
  String currentPage = "FAQ";
  String name = 'John Smith';
  final fieldText = TextEditingController();
  String token;
  bool isAdmin;
  var listOfQ;

  OurFAQ(
      {Key? key,
      required this.token,
      required this.name,
      required this.isAdmin,
      required this.listOfQ})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num numQuest = listOfQ.length;
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
                      "RECENTLY ASKED QUESTIONS",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                for(var i=0; i<numQuest; i++) 
                  Wrap(
                    children: <Widget>[
                      if(listOfQ[i]["answers"].length != 0)
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          //QUESTIONS
                          RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                text: "\u2022 ",
                              ),
                              TextSpan(
                                text: listOfQ[i]["question"],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //ANSWERS
                        for(int j=0; j<listOfQ[i]["answers"].length; j++)
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                text: "   ",
                              ),
                              TextSpan(
                                text: listOfQ[i]["answers"][j],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),

                          const SizedBox(
                            height: 20.0,
                          ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),

                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "Ask Our Admins Questions",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black)),
                  child: Center(
                    child: TextField(
                      controller: fieldText,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              /* Clear the search field */
                              fieldText.clear();
                            },
                          ),
                          hintText: "  What can we help you with?",
                          border: InputBorder.none),
                      onSubmitted: (value) async {
                        APICall.askQuestionRequest(token, fieldText.text);
                        fieldText.clear();
                      },
                    ),
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
