import 'package:ws/services/card_service.dart';

class AuthenticateCard {
  final CardService _cardService;

  AuthenticateCard(this._cardService);

  Future<int> execute(String cardValue) async {
    return await _cardService.sendAuthenticateCard(cardValue);
  }
}
