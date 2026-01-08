import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatRepository {
  final String chatRoomId;  // e.g., sorted user IDs: 'user1_user2'

  ChatRepository(this.chatRoomId);

  Stream<List<Message>> getMessages() {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromDoc(doc)).toList());
  }

  Future<void> sendMessage(String text, String senderId) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}