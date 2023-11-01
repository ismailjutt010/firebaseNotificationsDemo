import 'package:demonitification/notification_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
   // notificationServices.isTokenRefresh();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
    });
    notificationServices.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firebase Notification',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
        Center(
          child: TextButton(onPressed: ()async{
            notificationServices.getDeviceToken().then((value) {

              print(value);
            });
          } , child: Text('get Token')),
        )
      ],),
    );
  }
}
