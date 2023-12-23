import 'package:android/pages/charge_mode_page.dart';
import 'package:android/pages/charging_history.dart';
import 'package:android/pages/login_page.dart';
import 'package:android/pages/rfid_cards_page.dart';
import 'package:flutter/material.dart';
import 'package:android/pages/user_mode_interface.dart';
import 'package:android/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:android/pages/start_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'EVCharge App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const StartMenu(),
        debugShowCheckedModeBanner: false,
        routes: {
          'myHomePageRoute': (context) => const MyHomePage(),
          'registrationRoute': (context) => const LoginPage(),
          'chargeModePageRoute': (context) => const ChargeModePage(),
          'chargeHistoryPage': (context) => const ChargingHistoryPage(),
          'startMenuRoute': (context) => const StartMenu(),
          'rfidCardsPage': (context) => const RfidCardsPage(),
        }
      )
    );
  }
}
