import 'package:chatgpt/models/message.dart';
import 'package:chatgpt/services/injection.dart';
import 'package:chatgpt/states/message_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final List<Message> messages = [
  Message(content: 'Hello!', isUser: true, timestamp: DateTime.now()),
  Message(content: 'How are you!', isUser: false, timestamp: DateTime.now()),
  Message(content: 'Fine!', isUser: true, timestamp: DateTime.now()),
  Message(content: 'I am fine!', isUser: false, timestamp: DateTime.now()),
];

final _textController = TextEditingController();

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return MessageItem(message: messages[index]);
                },
                itemCount: messages.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 16, // 分割线
                ),
              ),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  hintText: 'Type your message',
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _sendMessage(ref, _textController.text);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  _requestChatGPT(WidgetRef ref, String content) async {
    final res = await chatgpt.sendChat(content);
    final text = res.choices.first.message?.content ?? "";
    final message = Message(
      content: text,
      isUser: false,
      timestamp: DateTime.now(),
    );
    ref.read(messageProvider.notifier).addMessage(message);
  }

  /// 发送消息
  _sendMessage(WidgetRef ref, String content) {
    /// 本地发送
    // final message =
    //     Message(content: content, isUser: true, timestamp: DateTime.now());
    // ref.read(messageProvider.notifier).addMessage(message); // 添加消息
    // _textController.clear();

    /// 请求ChatGPT服务
    _requestChatGPT(ref, content);
    _textController.clear();
  }
}

/// 消息列表项目
class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: message.isUser ? Colors.blue : Colors.grey,
          child: Text(message.isUser ? 'A' : 'GPT'),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(message.content),
      ],
    );
  }
}
