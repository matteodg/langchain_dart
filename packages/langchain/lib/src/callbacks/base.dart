import 'package:langchain/langchain.dart';

abstract class BaseCallbackHandler implements LLMManagerMixin, ChatModelManagerMixin {}

mixin LLMManagerMixin {
  void onLLMStart(
    final String prompt,
    final LLMOptions? options,
  );

  void onLLMEnd(
    final LLMResult llmResult,
  );
}

mixin ChatModelManagerMixin {
  void onChatModelStart(
    final List<ChatMessage> messages,
    final ChatModelOptions? options,
  );

  void onChatModelEnd(
    final ChatResult chatResult,
  );
}
