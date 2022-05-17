// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:train_trax/utils/urls.dart';
import 'package:train_trax/utils/ProfileBar.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:train_trax/utils/APICall.dart';


class OurAdminFAQ extends StatelessWidget {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');
  final fieldText = TextEditingController();
  String currentPage = "ADMIN FAQ";
  String name ='John Smith';
  TextEditingController answerController = TextEditingController();
  var _hover = false;
  int maxLine = 8;
  var listOfQ;
  var numQuest = 0;

  String token;
  bool isAdmin = true;

  OurAdminFAQ({Key? key, required this.token, required this.name, required this.listOfQ}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    numQuest = listOfQ.length;
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

                SizedBox(
                  height: 20.0,
                ),

                NavBar.createAdminNavBar(context, currentPage, token, name),

                //QUESTIONS FOR ADMIN
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "QUESTIONS FOR ADMIN",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(
                  height: 20.0,
                ),

                Wrap(
                  children: <Widget>[
                    //QUESTIONS
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                        width: 500.0,
                        child: Text(
                          "QUESTIONS",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                ),

                SizedBox(
                  height: 20.0,
                ),

                for(var i=0; i<numQuest; i++) 
                  Wrap(
                    children: <Widget>[
                      //QUESTIONS
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        width: 500.0,
                        child: RichText(
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
                              TextSpan(
                                text: listOfQ[i]["question"],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //ANSWER BUTTON
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: RaisedButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Text(
                                "Answer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => 
                              Dialog(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Container(
                                          height: 6*24,
                                          decoration: BoxDecoration(
                                            color: Colors.white, 
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: Colors.black)
                                          ),
                                          child: TextField(
                                            controller: answerController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(

                                              ),
                                            ),
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 6,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),

                                      RaisedButton(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 100),
                                          child: Text(
                                            "Send",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          //send response
                                          APICall.answerQuestionRequest(token, listOfQ[i]["question_id"].toString(), answerController.text);
                                          Navigator.pop(context, answerController.text);
                                          answerController.clear();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
