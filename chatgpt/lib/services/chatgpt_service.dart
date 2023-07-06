import 'package:openai_api/openai_api.dart';

class ChatGPTService {
  final client = OpenaiClient(
    config: OpenaiConfig(
      apiKey: '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',
    ),
  );

  Future<ChatCompletionResponse> sendChat(String content) async {
    final request = ChatCompletionRequest(
        model: Model.gpt3_5Turbo,
        messages: [ChatMessage(content: content, role: ChatMessageRole.user)]);

    return await client.sendChatCompletion(request);
  }
}
