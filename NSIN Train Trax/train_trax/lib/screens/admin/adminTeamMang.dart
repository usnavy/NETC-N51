// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:train_trax/utils/APICall.dart';
import 'package:train_trax/utils/urls.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:train_trax/utils/profile.dart';
import 'package:train_trax/screens/admin/local_widgets/adminTeamMangForm.dart';


class OurAdminTeamMang extends StatelessWidget {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');
  final addMember = TextEditingController();
  final newTeam = TextEditingController();
  String currentPage = "MANAGE_TEAMS";
  String name ='John Smith';
  List<String> listOfM = ['John Smith1', 
                          'John Smith2',
                          'John Smith3',
                          'John Smith4',
                          'John Smith5',
                          'John Smith6'];
  var numTeamates = 6;
  var _hover = false;
  var teamateNum =0;
  bool isAdmin =true;
  var listOfTeams;
  var numTeams = 0;

  String token;
  List<bool>  delete = [false, 
                          false,
                          false,
                          false,
                          false,
                          false];

  OurAdminTeamMang({Key? key, required this.token, required this.name, required this.listOfTeams}) : super(key: key);
  @override
  
  Widget build(BuildContext context) {
    List<String> listOfTeamsName = <String>[];
    for(int i=0; i<listOfTeams.length; i++){
      listOfTeamsName.add(listOfTeams[i]["team_name"]);
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
                SizedBox(
                  height: 20.0,
                ),
                NavBar.createAdminNavBar(context, currentPage, token, name),

                SizedBox(
                  height: 20.0,
                ),

                Center(
                  child: DropDown(token: token, name: name, listOfTeams: listOfTeams, listOfTeamsName: listOfTeamsName,),
                ),

                SizedBox(
                  height: 20.0,
                ),

                SizedBox(
                  height: 20.0,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                      child: Text(
                      "New Team:",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ),

                SizedBox(
                  height: 10.0,
                ),

                //create team
               Wrap(
                 alignment: WrapAlignment.center,
                 children: [
                    Container(
                      child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Text(
                      "Team Name",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                  ),

                ),
                    ),

                    Container(
                      width: 750,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)
                        ),
                    
                      child: TextField(
                        controller: newTeam,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                /* Clear the search field */
                                 newTeam.clear(); 
                              },
                            ),
                            hintText: '',
                            border: InputBorder.none),
                      ),
                      ),
                Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: RaisedButton(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Text(
                            "Create",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        onPressed: () async{
                          //create team
                          await APICall.createTeamRequest( token, newTeam.text);
                          _toManageTeams(context: context, tokn: token, name: name);
                        },
                      ),
                      ),
                 ],
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
}
