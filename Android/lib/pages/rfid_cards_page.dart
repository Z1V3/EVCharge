import 'dart:convert';
import 'package:android/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:android/privateAddress.dart';

class RfidCardsPage extends StatefulWidget {
  const RfidCardsPage({Key? key}) : super(key: key);

  @override
  State<RfidCardsPage> createState() => _RfidCardsPageState();
}

class _RfidCardsPageState extends State<RfidCardsPage> {
  List rfidCardsData = [
    {'cardID': '1234567890', 'cardName': 'FOI', 'cardID': '1234567890'},
    {'cardID': '9876543210', 'cardName': 'SICK Mobilisis', 'cardID': '9876543210'},
    {'cardID': '0987654321', 'cardName': 'ChronWard', 'cardID': '0987654321'},
  ]; //dummy data for page layout

/*class _RfidCardsPageState extends State<RfidCardsPage> {
  List rfidCardsData = [];
  bool _isLoading = false;*/

  /*Future<void> fetchRfidCards() async {
    setState(() {
      _isLoading = true;
    });
    final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;
    final url = 'http://${returnAddress()}:8080/api/card/getUserCards/$userId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      rfidCardsData = json;
      _isLoading = false;
    });
  }*/

  void fetchRfidCards() async {

    final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;
    print('Fetching history');
    final url = 'http://${returnAddress()}:8080/api/card/getUserCards/$userId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      rfidCardsData = json;
      //_isLoading = false;
    });
    print(json);
  }

  @override
  void initState() {
    super.initState();
    fetchRfidCards();
  }

  @override
  Widget build(BuildContext context) {
    /*if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'My RFID Cards',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: ListView.builder(
          itemCount: rfidCardsData.length,
          itemBuilder: (context, index) {
            final rfidCard = rfidCardsData[index];
            final cardID = rfidCard['cardID'];
            return Card(
                child: ListTile(
                leading: CircleAvatar(
                child: Text('${index + 1}'),
            ),
              title:  Text(' ${rfidCard['cardName']}',
                style: const TextStyle(
                color: Colors.black,
                ),
              ),

              onTap: () {
                _showPopUp(context, rfidCard);
              },
            ));
          },
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'addRfidCardRoute');
            },
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}

void _showPopUp(BuildContext context, Map<String, dynamic> cardData) {
  final card = RfidCard(cardData['cardID'], cardData['cardName']);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Card Details'),
        content: Text('Card ID: ${card.cardID}\nCard Name: ${card.cardName}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

class RfidCard {
  final String cardID;
  final String cardName;

  RfidCard(this.cardID, this.cardName);
}