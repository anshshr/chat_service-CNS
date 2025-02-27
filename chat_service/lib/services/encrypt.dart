import 'package:crypto/crypto.dart';
import 'dart:convert';

class ChatEncryption {
  late String sharedKey;

  ChatEncryption(String senderId, String receiverId) {
    sharedKey = generateKey(senderId, receiverId);
  }

  // Generate a 32-character key based on sender & receiver IDs
  String generateKey(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort(); // Ensure order remains consistent
    String combined = ids.join("_");
    return sha256.convert(utf8.encode(combined)).toString().substring(0, 32);
  }

  // Encrypt message
  String encryptMessage(String message) {
    return base64.encode(utf8.encode(message)); // Simple Base64 encryption
  }

  // Decrypt message
  String decryptMessage(String encryptedMessage) {
    return utf8.decode(base64.decode(encryptedMessage));
  }
}
