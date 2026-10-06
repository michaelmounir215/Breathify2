import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/support_chat_model.dart';
import '../../providers/user_provider.dart';
import '../../services/database_service.dart';
import '../role_selection_screen.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final _messageController = TextEditingController();

  void _sendMessage(String userId) async {
    if (_messageController.text.isNotEmpty) {
      await _databaseService.createSupportMessage(
        userId: userId,
        message: _messageController.text,
        isFromUser: true,
      );
      _messageController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<SupportChatModel>>(
              future: _databaseService.getSupportMessages(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data![index];
                    return ListTile(
                      title: Text(message.message),
                      trailing: Text(message.isFromUser ? 'You' : 'Support'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(user.id),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}