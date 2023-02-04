import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3_193059/model/location.dart';
import 'package:intl/intl.dart';
import 'package:lab3_193059/model/list_item.dart';
import 'package:lab3_193059/screens/signin_screen.dart';
import '../widgets/new_item.dart';
import 'calendar_screen.dart';
import 'package:lab3_193059/screens/google_map_screen.dart';
import 'package:lab3_193059/services/notifications.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "mainScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotificationService notificationService;

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initialize();
    super.initState();
  }

  final List<ListKolokviumi> _userKolokviumi = [
    ListKolokviumi(
        id: "1",
        imeNaPredmet: "MIS",
        datumVreme: DateTime.parse("2022-10-13 18:00:00"),
        //42.00510322106074, 21.406963518278882
        lokacija: Location(
            latitude: 42.00510322106074, longitude: 21.406963518278882)),
    ListKolokviumi(
        id: "2",
        imeNaPredmet: "VIS",
        datumVreme: DateTime.parse("2022-01-22 12:00:00"),
        //42.00498661107486, 21.40817371317485
        lokacija: Location(
            latitude: 42.00498661107486, longitude: 21.40817371317485)),
    ListKolokviumi(
        id: "3",
        imeNaPredmet: "APS",
        datumVreme: DateTime.parse("2022-01-17 15:00:00"),
        //42.004736818370006, 21.40988312815307
        lokacija: Location(
            latitude: 42.004736818370006, longitude: 21.40988312815307)),
  ];

  void _addItemFunction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NovoPolaganje(_addNewItemToList),
          );
        });
  }

  void _addNewItemToList(ListKolokviumi item) {
    setState(() {
      _userKolokviumi.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _userKolokviumi.removeWhere((elem) => elem.id == id);
    });
  }

  String _modifyDate(DateTime date, Location location) {
    String lokacija = '';
    //42.00510322106074, 21.406963518278882
    if (location.latitude == 42.00510322106074 &&
        location.longitude == 21.406963518278882) {
      lokacija = 'FINKI';
    } //42.00498661107486, 21.40817371317485
    else if (location.latitude == 42.00498661107486 &&
        location.longitude == 21.40817371317485) {
      lokacija = 'FEIT';
    } //42.004736818370006, 21.40988312815307
    else {
      lokacija = 'TMF';
    }

    String dateToString = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    List<String> parts = dateToString.split(" ");
    String modifiedTime = parts[1].substring(0, 5);
    return parts[0] + ' | ' + modifiedTime + 'h' + ' ' + lokacija;
  }

  Future _signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        print("User is signed out");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR");
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upcoming exams"),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () => _addItemFunction(context),
            ),
            ElevatedButton(
              child: Text("Sign out"),
              onPressed: _signOut,
            )
          ],
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: _userKolokviumi.isEmpty
                    ? Text("No exams upcoming")
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _userKolokviumi.length,
                        itemBuilder: (ctx, index) {
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 10),
                            child: ListTile(
                              tileColor: Colors.pink[100],
                              title: Text(
                                _userKolokviumi[index].imeNaPredmet,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                _modifyDate(_userKolokviumi[index].datumVreme,
                                    _userKolokviumi[index].lokacija),
                                style: TextStyle(color: Colors.black54),
                              ),
                              trailing: IconButton(
                                  onPressed: () =>
                                      _deleteItem(_userKolokviumi[index].id),
                                  icon: Icon(Icons.delete_outline_rounded)),
                            ),
                          );
                        },
                      ),
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  size: 30,
                ),
                label: Text(
                  "Calendar",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CalendarScreen(_userKolokviumi)));
                },
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.map_outlined,
                    size: 30,
                  ),
                  label: Text(
                    "Locations Map",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GoogleMapPage(_userKolokviumi)));
                  },
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.notifications_active,
                  size: 30,
                ),
                label: Text(
                  "Show Notification",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  await notificationService.showNotification(
                      id: 0,
                      title: 'Exams session is close',
                      body: 'Check your calendar');
                },
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.edit_notifications_outlined,
                  size: 30,
                ),
                label: Text(
                  "Schedule Notification",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  //notification appears after 4 seconds
                  await notificationService.showScheduledNotification(
                      id: 0,
                      title: 'Exams session is close',
                      body: 'Check your calendar',
                      seconds: 2);
                },
              ),
            ],
          ),
        )));
  }
}
