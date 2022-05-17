import 'package:flutter/material.dart';
import 'package:train_trax/utils/ProfileBar.dart';
import 'package:train_trax/utils/NavBar.dart';
import 'package:train_trax/widgets/TopBar.dart';
import 'package:train_trax/utils/urls.dart';

class OurTeamStatistics extends StatelessWidget {
  String currentPage = "TEAM STATS";
  String name = 'John Smith';
  String token;
  bool isAdmin = true;
  var teamStats;

  OurTeamStatistics(
      {Key? key,
      required this.token,
      required this.name,
      required this.teamStats})
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
                  height: 25.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      child: Center(
                        child: Text(
                          "OVERALL STATISTICS",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Total Articles Started: " +
                                        teamStats["stats"]
                                                ["total_articles_started"]
                                            .toString()),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Average Articles Started: " +
                                        teamStats["stats"]
                                                ["average_articles_started"]
                                            .toString()),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Average Articles Completed: " +
                                        teamStats["stats"]
                                                ["average_articles_completed"]
                                            .toString()),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text: "Total Articles Completed: " +
                                        teamStats["stats"]
                                                ["total_articles_completed"]
                                            .toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Divider(
                  height: 5,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "TEAM STATS",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Center(
                  child: MyStatefulWidget(),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "MOST RECENTLY VIEWED",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "TEAMS OVERALL (%) COMPLETED",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),

                for (var i = 0; i < 5; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "testing",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "%",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),

                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "Team Members",
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

//Dropdown
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Team 1';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconEnabledColor: Theme.of(context).secondaryHeaderColor,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
      underline: Container(
        height: 2,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Team 1', 'Team 2', 'Team 3', 'Team 4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
