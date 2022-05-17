import 'package:flutter/material.dart';

class Profile {
  String? name = null;

  void setPage(String? pname){
    name=pname;

  }

  static Container createProfile(BuildContext context, String name, bool thridlline){
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Wrap(
          children: <Widget>[
            Icon(
              Icons.person,
              size: 40.0,
            ),

            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),

                Text(
                  'U.S. Navy',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),

                if(thridlline)
                  Text(
                    'Pride, Honor, Integrity',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
