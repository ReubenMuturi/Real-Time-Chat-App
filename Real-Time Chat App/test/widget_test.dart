import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_time_chat/main.dart';
import 'package:real_time_chat/screens/chat_screen.dart';
import 'package:real_time_chat/screens/login_screen.dart';

void main() {
  group('Real-Time Chat App Widget Tests', () {
    late MockFirebaseAuth mockAuth;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('Login screen shows email and password fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MyApp()),
      );

      expect(find.byType(TextField), findsExactly(2));
      expect(find.textContaining('Email'), findsOneWidget);
      expect(find.textContaining('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Chat screen displays messages when logged in', (tester) async {
      final mockUser = MockUser(uid: 'test_user_id');
      mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

      // Simulate some messages
      final chatRoomId = 'demo_partner_id_test_user_id';
      final messagesRef = fakeFirestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages');

      await messagesRef.add({
        'text': 'Hello!',
        'senderId': 'test_user_id',
        'timestamp': Timestamp.now(),
      });

      await messagesRef.add({
        'text': 'Hi there!',
        'senderId': 'demo_partner_id',
        'timestamp': Timestamp.now(),
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override Firebase providers if needed in real app
          ],
          child: MaterialApp(
            home: ChatScreen(currentUserId: 'test_user_id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello!'), findsOneWidget);
      expect(find.text('Hi there!'), findsOneWidget);
    });

    testWidgets('Typing indicator appears and disappears', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypingIndicator(isTyping: true),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsNWidgets(3));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypingIndicator(isTyping: false),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircleAvatar), findsNothing);
    });
  });
}