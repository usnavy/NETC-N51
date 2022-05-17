// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:train_trax/screens/admin/adminTeamMang.dart';
import 'package:train_trax/utils/APICall.dart';

import '../../../utils/profile.dart';


class DropDown extends StatefulWidget {
  //List<String> listOfM;
  List<String> listOfTeamsName;
  var listOfTeams;
  String token;
  String name;
  DropDown({Key? key, required this.token, required this.name, required this.listOfTeams, required this.listOfTeamsName}) : super(key: key);
  

  @override
  State<DropDown> createState() => _MyDropDown( token: token, name: name, listOfTeams: listOfTeams, listOfTeamsName: listOfTeamsName);
}

class _MyDropDown extends State<DropDown> {
  final addMember = TextEditingController();
  List<String> listOfTeamsName;
  late String dropdownValue = listOfTeamsName.elementAt(0);

  late var numTeamates=listOfTeams[0]["users"].length;
  late var numTeams = listOfTeams.length;
  late var listOfTeams;
  late String teamId;
  int teamNum = 0;
  String token;
  String name;

  _MyDropDown({ required this.token, required this.name, required this.listOfTeams, required this.listOfTeamsName});
  late List<bool>  delete = List.filled(numTeamates, false);

  void refreshTeams({
    required String token,
  }) async {
    try {
      Response _returnString;
      var decoded;

      _returnString = (await APICall.getUserInfo(token)) as Response;
      decoded = jsonDecode(_returnString.body);
     
      if (_returnString.statusCode == 200) {
        setState(() {
          listOfTeams: decoded["teams_admin"];
        });
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(decoded["message"]),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void addUser({
    required String token,
    required String teamId,
    required String userName,
  }) async {
    try {
      var _returnResponse;
      var decoded;

      _returnResponse = (await APICall.getUsers(token));
      //decoded = jsonDecode(_returnResponse.body);
      var listOfUsers = _returnResponse;
     
      if (_returnResponse != null) {
        for(int i=0; i<listOfUsers.length; i++){
          if(listOfUsers[i]["name"] == userName){
            String _returnString;
            _returnString = (await APICall.addMemberRequest(token, teamId, listOfUsers[i]["user_id"].toString()));
            if(_returnString== "success"){
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("You have add a member"),
                  duration: Duration(seconds: 3),
                ),
              );
            }
            else{
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Member has not been added"),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        }
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(decoded["message"]),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    late List<dynamic> listOfM = listOfTeams[0]["users"];
    for(int i=0; i<listOfTeams.length;i++){
      if(dropdownValue == listOfTeams[i]["team_name"]){
        teamId = listOfTeams[i]["team_id"].toString();
        listOfM = listOfTeams[i]["users"];
        numTeamates = listOfM.length;
        teamNum = i;
        break;
      }
    }

    return Column(
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;

            });
          },
          items: listOfTeamsName
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        //teammate
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            for(int i=0; i<numTeamates; i++)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 23.0,
                          child: IconButton(
                            alignment: Alignment.bottomCenter,
                            splashRadius: 26,
                            icon: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed:  () {
                              //remove from team
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => 
                                Dialog(
                                  child: Center(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 6*24,
                                            child: Text(
                                              "Do you want to remove this member from the team"
                                            ),
                                          ),
                                        ),

                                        Wrap(
                                          spacing: 20.0,
                                          children: [
                                            RaisedButton(
                                                child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 100),
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async{
                                                //delete[i] = true;
                                                //delete members
                                                APICall.deleteMemberRequest( token,  listOfTeams[teamNum]["team_id"].toString(),  listOfM[i]["user_id"].toString());
                                                Response _returnString;
                                                var decoded;

                                                _returnString = (await APICall.getUserInfo(token)) as Response;
                                                decoded = jsonDecode(_returnString.body);
                                                if (_returnString.statusCode == 200) 
                                                  setState(() {
                                                    listOfTeams: decoded["teams_admin"];
                                                  });
                                                //Navigator.pop(context);
                                              },
                                            ),

                                            RaisedButton(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 100),
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                delete[i] = false;
                                                Navigator.pop(context, delete);
                                              },
                                            )

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      child:Profile.createProfile(context, listOfM[i]["name"], true),
                    ),
                  ],
                ),
              ),
          ],
        ),
        
        //add member
            Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                  width: 750,
                  height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)
                        ),
                    child: Center(
                      child: TextField(
                        controller: addMember,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                /* Clear the search field */
                                 addMember.clear(); 
                              },
                            ),
                            hintText: 'Team Member',
                            border: InputBorder.none),
                      ),
                    ),
                ),
                
                Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: RaisedButton(
                        child: Padding(
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
                          //add team member
                          addUser(token: token, teamId: teamId, userName: addMember.text);

                        },
                      ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),

                Center(
                  child: RaisedButton(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Text(
                            "Delete Team",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        onPressed: () async{
                          //delete team
                          await APICall.deleteTeamRequest(token, teamId);
                          _toManageTeams(context: context, tokn: token, name: name);

                        },
                      ),
                ),
      ],
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
