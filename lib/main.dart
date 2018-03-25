import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'driverdash.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final googleSignIn = new GoogleSignIn();
final reference = FirebaseDatabase.instance.reference();

void goToDriverDash(BuildContext context, FirebaseUser _user) {
  //Navigator.of(context).pushNamed('/DriverDashboard');
  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new DriverDashStateless(googleSignIn, _user)));
}

void SendDataToFirebase(FirebaseUser user, BuildContext context) {
  final uid = user.uid;
  final driverRef = reference.child('drivers/');
  final UserRef = reference.child('drivers/$uid');

  driverRef.child(uid).once().then((DataSnapshot snapshot) {
    print('!!!!HEREE!!!!');
    print(snapshot.key);
    print(snapshot.value);
  });

  UserRef.set({
    'DisplayName': user.displayName,
    'Email': user.email,
    'uid': user.uid,
    'photoUrl': user.photoUrl,
    'verified': user.isEmailVerified,
    'milesTravelled': 0,
    'tripsTaken': 0,
    'timeDriven': 0
  });
  print('!!!!AFTER!!!');
  goToDriverDash(context, user);
}

void _testSignInWithGoogle(BuildContext context) async {
  await googleSignIn.signOut();
  final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final FirebaseUser user = await auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  assert(user.email != null);
  assert(user.displayName != null);
  assert(!user.isAnonymous);
  //assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await auth.currentUser();
  assert(user.uid == currentUser.uid);
  SendDataToFirebase(currentUser, context);
}

void main() => runApp(new MyApp());

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null)
    user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login Activity',
      /*routes: <String, WidgetBuilder> {
        '/DriverDashboard': (BuildContext context) => new Driverdash(googleSignIn, )
      },*/
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class Helper {
  BuildContext context;
  Helper(BuildContext _context) {
    this.context = _context;
  }
  void CallLogin() {
    _testSignInWithGoogle(context);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  void GoogleLogin(BuildContext context) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _testSignInWithGoogle(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Please Login/Register To Continue',
            ),
            new RaisedButton(child: new Text("Login") ,onPressed: (new Helper(context)).CallLogin , color: Colors.blue,),
          ],
        ),
      ),
      /*floatingActionButton: new FloatingActionButton(
        onPressed: GoogleLogin,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),*/
    );
  }
}
