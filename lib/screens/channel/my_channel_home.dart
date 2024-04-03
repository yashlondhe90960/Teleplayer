import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleplay/components/movie_tile.dart';
import 'package:teleplay/screens/channel/analytics_screen.dart';
import 'package:teleplay/screens/channel/earn_screen.dart';

class MyChannelHome extends StatefulWidget {
  const MyChannelHome({super.key});

  @override
  State<MyChannelHome> createState() => _MyChannelHomeState();
}

class _MyChannelHomeState extends State<MyChannelHome> {
  late String name = "";
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

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString("name");
    print(name);
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Your Channel",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                          "https://cdn-icons-png.flaticon.com/512/3237/3237447.png"),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.video_collection,
                ),
                title: const Text('Content'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Analytics'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AnalyticsPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () {
                  sendFeedback();
                },
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const Text('Earn'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EarnPage()));
                },
              ),
            ],
          ),
        ),
        body: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [MovieTile()],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.upload_file,
            color: Colors.white,
          ),
        ));
  }
}
