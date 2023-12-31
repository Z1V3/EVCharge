import 'dart:async';
import 'dart:convert';
import 'package:android/pages/charging_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:android/privateAddress.dart';
import 'package:android/providers/user_provider.dart';
import 'package:provider/provider.dart';


class ChargeModePage extends StatefulWidget {
  const ChargeModePage({Key? key}) : super(key: key);

  @override
  State<ChargeModePage> createState() => _ChargeModePageState();
}

class ChargingData {
  String startTime;
  String endTime;
  String chargeTime;
  double volume;
  double price;
  int userID;
  int chargerID;

  ChargingData({
    required this.startTime,
    required this.endTime,
    required this.chargeTime,
    required this.volume,
    required this.price,
    required this.userID,
    required this.chargerID,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'chargeTime': chargeTime,
      'volume': volume,
      'price': price,
      'userID': userID,
      'chargerID': chargerID,
    };
  }
}

class _ChargeModePageState extends State<ChargeModePage>{
  double counter = 0.00;
  double volumeCharge = 0.00, priceCharge = 0.00;

  late Timer _timer;
  bool isRunning = false;

  String formattedDateTimeStart = "/", formattedDateTimeEnd = "/", formattedDuration = "/";
  final TextEditingController _textFieldController = TextEditingController();
  int globalUserID = 0;

  String formatCounterToDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int minutes = duration.inMinutes % 60;
    int remainingSeconds = duration.inSeconds % 60;

    int hours = duration.inHours;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

    Future<void> sendChargerOccupation(int chargerID, bool occupied) async {
    final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/charger/updateChargerAvailability');

    try {

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chargerID': chargerID,
          'occupied': occupied,
        }),
      );

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }

  Future<void> sendCreateEvent(String startTime, String endTime, String chargeTime, double volume, double price) async {
    final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/event/createEvent');

    int userID = Provider.of<UserProvider>(context, listen: false).user?.userID ?? 0;
    globalUserID = userID;
    try {
      ChargingData chargingData = ChargingData(
        startTime: startTime,
        endTime: endTime,
        chargeTime: chargeTime,
        volume: volume,
        price: price,
        userID: userID,
        chargerID: 2,
      );

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(chargingData.toJson()),
      );

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        counter++;
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onPressStart() {
    if (!isRunning) {
      startTimer();
      setState(() {
        isRunning = true;
      });
      sendChargerOccupation(1, true);
      DateTime now = DateTime.now();
      formattedDateTimeStart = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    }
    print('START button clicked');
  }

  void onPressStop() {
    if (isRunning) {
      stopTimer();

      DateTime now = DateTime.now();
      formattedDateTimeEnd = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);

      counter = counter/10;
      int unformattedDuration = counter.toInt();
      formattedDuration = formatCounterToDuration(unformattedDuration);

      volumeCharge = double.parse(((counter*2.361)/10).toStringAsExponential(3));
      priceCharge = double.parse(((counter*1.5)/10).toStringAsExponential(3));


      sendChargerOccupation(1, false);
      sendCreateEvent(formattedDateTimeStart, formattedDateTimeEnd, formattedDuration, volumeCharge, priceCharge);
    }
    print('UserID: $globalUserID');
    print('Time charged: $counter seconds');
    print('Power: $volumeCharge');
    print('Price: $priceCharge');
    counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      Navigator.pushReplacementNamed(context, 'startMenuRoute');
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charge Mode'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.black87,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 40),
              const Text(
                //'Welcome, ${widget.userName}', // Display the welcome message with the user's name
                'Welcome, Ivan Horvat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(child: Center(
                child: Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleButton(
                        label: 'START',
                        onClick: !isRunning ? () => onPressStart() : null,
                      ),
                      const SizedBox(height: 20),
                      CircleButton(
                        label: 'STOP',
                        onClick: isRunning ? () => onPressStop() : null,
                      ),
                    ],
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onClick;

  const CircleButton({super.key, required this.label, this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(30),
        backgroundColor: Colors.blue,
        minimumSize: const Size(200, 200),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}