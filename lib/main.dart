import 'dart:async';
import 'dart:convert';

// import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:notification_testing/audio_handler.dart';
import 'package:notification_testing/notification_model.dart';
import 'package:notification_testing/notification_service.dart';
import 'package:notification_testing/print_payload_received.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// late AudioPlayerHandler audioHandler;

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    NotificationService.configureLocalTimeZone();
    await NotificationService.init();
    // await startService();

    runApp(const MyApp());
  }, (error, stack) => print(error));
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage event) async {
  print("FirebaseMessaging recieved ${event.data}");
  print("FirebaseMessaging recieved ${event.notification?.body}");
}

// Future<void> startService() async {
//   audioHandler = await AudioService.init(
//     builder: () => AudioPlayerHandlerImpl(),
//     config: const AudioServiceConfig(
//       androidNotificationChannelId: 'com.nispand.com',
//       androidNotificationChannelName: 'Nispand Audio',
//       androidStopForegroundOnPause: true,
//       // androidNotificationOngoing: true,
//       androidNotificationIcon: 'mipmap/ic_launcher',
//       androidShowNotificationBadge: true,
//       // notificationColor: Colors.grey[900],
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Notification bug',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Notification bug'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getToken();
    firebaseMessage();
    super.initState();
  }

  getToken() async {
    try {
      String? token =
          await FirebaseMessaging.instance.getToken();
      print(token);
    } catch (_) {}
  }

  firebaseMessage() async {
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessage.listen(createFCMNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(onOpenFCMNotification);
  }

  createFCMNotification(RemoteMessage event) async {
    print("message handler called for foreground state");
    String screenType = event.data['screen'] ?? "";
    int notificationId = int.parse(event.data['id'] ?? "211232");
    String title = event.notification?.title ?? "";
    String body = event.notification?.body ?? "";

    print(
        "createFCMNotification screenType $screenType, Data: ${event.data}, Body: ${event.notification?.body}");
    TextNotification genericObj = TextNotification(
        title: title,
        screenType: "none",
        notificationId: notificationId,
        sentAt: DateTime.parse(
            event.data["sent_at"] ?? DateTime.now().toUtc().toString()));
    NotificationService.showNotification(
        title: title,
        body: body,
        payload: json.encode(genericObj.toJson()),
        id: notificationId);
  }

  onOpenFCMNotification(RemoteMessage event) async {
    print("onOpenFCMNotification called");
    String screenType = event.data['screen'] ?? "";
    int notificationId = int.tryParse(event.data['id']) ?? 211232;
    String title = event.notification?.title ?? "";
    String body = event.notification?.body ?? "";
    String payloadString = event.data != null && event.data.isNotEmpty
        ? json.encode(event.data)
        : "";

    // print(
    //     "onOpenFCMNotification screenType $screenType, Data: ${event.data}, Body: ${event.notification?.body}");

    try {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PrintPayloadReceived(payload: "");
      }));
    } catch (e) {
      print('"dcdscdscsdc');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DatePickerTxt(),
            ScheduleBtn(),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

DateTime scheduleTime = DateTime.now();

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);
      },
    );
  }
}
