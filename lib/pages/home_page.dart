import 'package:flutter/material.dart';
import 'package:google_login/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  GoogleSignInAccount? user; // Nullable user

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        user = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appBar(), // AppBar with profile image and menu
                    const SizedBox(height: 30),
                    greetingText(),
                    const SizedBox(height: 40),
                    userInfoCard(),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  // AppBar widget with user profile image and menu icon
  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            profileImage(),
            const SizedBox(width: 20),
          ],
        ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: _handleSignOut, // Logout button
        ),
      ],
    );
  }

  // Widget to display user profile image with status indicator
  Widget profileImage() {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            user?.photoUrl ?? '',
            height: 50,
            width: 50,
            errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
              );
            },
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: Colors.green[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // Greeting text widget
  Widget greetingText() {
    return Text(
      'Hello, ${user!.displayName}!',
      style: TextStyle(
        fontSize: 28,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // User information card widget
  Widget userInfoCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            userInfoRow(Icons.email, user!.email, Colors.blue),
            const SizedBox(height: 10),
            userInfoRow(Icons.person, user!.displayName!, Colors.green),
          ],
        ),
      ),
    );
  }

  // Widget to display user info rows
  Widget userInfoRow(IconData icon, String info, Color iconColor) {
    return Row(
      children: <Widget>[
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Text(
          info,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Handle user sign out
  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      user = null; // Reset user to null after sign out
      // Navigate to the Home Page if user is signed in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    });
  }
}
