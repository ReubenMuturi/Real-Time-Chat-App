import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';          // ← THIS LINE WAS MISSING
import '../repositories/chat_repository.dart';

final chatRepositoryProvider = Provider.family<ChatRepository, String>((ref, chatRoomId) {
  return ChatRepository(chatRoomId);
});

final messagesProvider = StreamProvider.family<List<Message>, String>((ref, chatRoomId) {
  final repo = ref.watch(chatRepositoryProvider(chatRoomId));
  return repo.getMessages();
});