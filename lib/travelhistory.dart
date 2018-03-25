import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';
import 'driverdash.dart';
import 'settings.dart';

class TravelHistory extends StatelessWidget {
  GoogleSignIn googleAccount;
  FirebaseUser firebaseAccount;

  TravelHistory(GoogleSignIn _googleAccount, FirebaseUser _firebaseAccount) {
    googleAccount = _googleAccount;
    firebaseAccount = _firebaseAccount;
    print("$firebaseAccount");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Travel History")),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader (
              accountName: new Text(firebaseAccount.displayName),
              accountEmail: new Text(firebaseAccount.email),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(firebaseAccount.photoUrl),
                ),
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage("https://www.pixelstalk.net/wp-content/uploads/wallpapers/Color-Chromebook-Wallpaper-HD-4.png")
                  )
              ),
            ),
            new ListTile(
              title: new Text("Drive"),
              trailing: new Icon(Icons.directions_car),
              enabled: true,
              onTap: () { Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new Driverdash(googleAccount, firebaseAccount))); },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Travel History"),
              trailing: new Icon(Icons.archive),
              enabled: false,
            ),
            new Divider(),
            new ListTile(
              title: new Text("Settings"),
              trailing: new Icon(Icons.settings),
              enabled: true,
              onTap: () { Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new Settings(googleAccount, firebaseAccount))); },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Log Out"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () { googleAccount.signOut(); Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new MyApp())); },
            ),
          ],
        ),
      ),
    );
  }
}