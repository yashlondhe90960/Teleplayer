import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleplay/screens/auth/screens/login_screen.dart';
import 'package:teleplay/screens/channel/my_channel_home.dart';
import 'package:teleplay/screens/home/download_page.dart';
import 'package:teleplay/screens/home/history_page.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? name;
  String? email;
  void getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
    });

    if (name == null || email == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void showAccountDetails() {
    getPref();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.blue[400],
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Account details",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Name: $name",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Email: $email",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ));
  }

  void sendFeedback() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blue[400],
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.feedback_rounded,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Help and Feedback",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hoverColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hoverColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: "Your message here",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Feedback sent")));
              Navigator.of(context).pop();
            },
            child: const Text(
              "Send",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  tileColor: Colors.blue,
                  title: Text("Remove ads",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                ListTile(
                  onTap: showAccountDetails,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  leading: const Icon(
                    Icons.person,
                  ),
                  title: const Text("Account",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const HistoryPage()));
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  leading: const Icon(
                    Icons.history_outlined,
                  ),
                  title: const Text("History",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const DownloadPage()));
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  leading: const Icon(
                    Icons.download,
                  ),
                  title: const Text("Download",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const MyChannelHome()));
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  leading: const Icon(
                    Icons.playlist_add_check_outlined,
                  ),
                  title: const Text("My Channel",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
                ListTile(
                  onTap: sendFeedback,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  leading: const Icon(
                    Icons.people_alt_outlined,
                  ),
                  title: const Text("Help and feedback",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
