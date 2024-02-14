import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ws/privateAddress.dart';

class CardService {
  Future<int> sendAddNewCard(int userID, String cardValue) async {
    try {
      final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/card/addNewCard');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'UserID': userID,
          'Value': cardValue,
        }),
      );

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
      return response.statusCode;
    } catch (e) {
      print('Error sending API request: $e');
    }
    return -1;
  }
}
