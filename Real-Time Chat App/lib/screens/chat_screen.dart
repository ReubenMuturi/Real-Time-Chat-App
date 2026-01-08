import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  const ChatScreen({super.key, required this.currentUserId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final String partnerId = 'demo_partner_id';  // In real app, select user
  late final String chatRoomId;
  final _msgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ids = [widget.currentUserId, partnerId]..sort();
    chatRoomId = ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(chatRoomId));

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (_, i) => MessageBubble(
                  message: messages[i],
                  isMe: messages[i].senderId == widget.currentUserId,
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Error loading messages'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'Type a message'))),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_msgCtrl.text.isNotEmpty) {
                      final repo = ref.read(chatRepositoryProvider(chatRoomId));
                      await repo.sendMessage(_msgCtrl.text, widget.currentUserId);
                      _msgCtrl.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}