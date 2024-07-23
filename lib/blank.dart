import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications = [
    'Notification 1',
    'Notification 2',
    'Notification 3',
    'Notification 4',
    'Notification 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationItem(notification: notifications[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String notification;

  const NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF212121),
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.notifications, color: Colors.white),
        title: Text(
          notification,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Placeholder notification description',
          style: TextStyle(color: Color(0xFFB3B3B3)),
        ),
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Notifications Page',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFF121212),
    ),
    home: Builder(
      builder: (context) => Scaffold(
        body: NotificationsPage(),
      ),
    ),
  ));
}
