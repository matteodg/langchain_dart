import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:langchain/langchain.dart';
import 'package:openai_dart/openai_dart.dart';

import 'models/models.dart';

/// {@template openai_whisper_loader}
/// A document loader that loads a [Document] from an audio file.
///
/// This loader reads an audio file located at [filePath] and extracts
/// [Document]s using OpenAI audio models based on the provided [defaultOptions].
///
/// Each [Document] represents a matching audio transcription found in the
/// file.
///
/// Example usage:
/// ```dart
/// final loader = OpenAIWhisperLoader('path/to/audio.mp3');
/// final documents = await loader.load();
/// ```
/// {@endtemplate}
class OpenAIWhisperLoader extends BaseDocumentLoader {
  /// {@macro openai_whisper_loader}
  OpenAIWhisperLoader(
    this.filePath, {
    final String? apiKey,
    final String? organization,
    final String? baseUrl,
    final Map<String, String>? headers,
    final Map<String, dynamic>? queryParams,
    final http.Client? client,
    this.defaultOptions = const OpenAIWhisperOptions(),
  }) : _client = OpenAIClient(
          apiKey: apiKey ?? '',
          organization: organization,
          baseUrl: baseUrl,
          headers: headers,
          queryParams: queryParams,
          client: client,
        );

  /// The file path of the audio file to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
  final String filePath;

  /// A client for interacting with OpenAI API.
  final OpenAIClient _client;

  /// The default options to use when calling the Whisper API.
  OpenAIWhisperOptions defaultOptions;

  @override
  Stream<Document> lazyLoad() async* {
    // TODO: split in 25MB chunks as size limit for Whisper API is 25MB
    if (File(filePath).lengthSync() > 25 * 1024 * 1024) {
      throw Exception('Files bigger than 25MB are not supported yet');
    }
    final multipartFile = await http.MultipartFile.fromPath('file', filePath);
    final request = [
      multipartFile,
    ];
    final transcriptionResponse = await _client.createTranscription(
      request: request,
      fields: {
        'model': defaultOptions.model,
        if (defaultOptions.language != null) 'language': defaultOptions.language!,
        if (defaultOptions.prompt != null) 'prompt': defaultOptions.prompt!,
        if (defaultOptions.responseFormat != null) 'response_format': defaultOptions.responseFormat!,
        if (defaultOptions.temperature != null) 'temperature': defaultOptions.temperature!.toString(),
      },
    );
    yield Document(
      pageContent: transcriptionResponse.text,
      metadata: {
        'file': filePath,
      },
    );
  }
}
