// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: invalid_annotation_target
part of open_a_i_schema;

// ==========================================
// CLASS: CreateTranscriptionRequest
// ==========================================

/// No Description
@freezed
class CreateTranscriptionRequest with _$CreateTranscriptionRequest {
  const CreateTranscriptionRequest._();

  /// Factory constructor for CreateTranscriptionRequest
  const factory CreateTranscriptionRequest({
    /// The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
    required String file,

    /// ID of the model to use. Only `whisper-1` is currently available.
    @_CreateTranscriptionRequestModelConverter()
    required CreateTranscriptionRequestModel model,

    /// The language of the input audio. Supplying the input language in [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) format will improve accuracy and latency.
    @JsonKey(includeIfNull: false) String? language,

    /// An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text/prompting) should match the audio language.
    @JsonKey(includeIfNull: false) String? prompt,

    /// The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
    @JsonKey(name: 'response_format')
    @Default(CreateTranscriptionRequestResponseFormat.json)
    CreateTranscriptionRequestResponseFormat responseFormat,

    /// The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
    @Default(0.0) double temperature,
  }) = _CreateTranscriptionRequest;

  /// Object construction from a JSON representation
  factory CreateTranscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTranscriptionRequestFromJson(json);

  /// List of all property names of schema
  static const List<String> propertyNames = [
    'file',
    'model',
    'language',
    'prompt',
    'response_format',
    'temperature'
  ];

  /// Validation constants
  static const temperatureDefaultValue = 0.0;

  /// Perform validations on the schema property values
  String? validateSchema() {
    return null;
  }

  /// Map representation of object (not serialized)
  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'model': model,
      'language': language,
      'prompt': prompt,
      'response_format': responseFormat,
      'temperature': temperature,
    };
  }
}

// ==========================================
// ENUM: CreateTranscriptionRequestModelEnum
// ==========================================

/// No Description
enum CreateTranscriptionRequestModelEnum {
  @JsonValue('whisper-1')
  whisper1,
}

// ==========================================
// CLASS: CreateTranscriptionRequestModel
// ==========================================

/// ID of the model to use. Only `whisper-1` is currently available.
@freezed
sealed class CreateTranscriptionRequestModel
    with _$CreateTranscriptionRequestModel {
  const CreateTranscriptionRequestModel._();

  /// No Description
  const factory CreateTranscriptionRequestModel.model(
    CreateTranscriptionRequestModelEnum value,
  ) = CreateTranscriptionRequestModelEnumeration;

  /// No Description
  const factory CreateTranscriptionRequestModel.modelId(
    String value,
  ) = CreateTranscriptionRequestModelString;

  /// Object construction from a JSON representation
  factory CreateTranscriptionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateTranscriptionRequestModelFromJson(json);
}

/// Custom JSON converter for [CreateTranscriptionRequestModel]
class _CreateTranscriptionRequestModelConverter
    implements JsonConverter<CreateTranscriptionRequestModel, Object?> {
  const _CreateTranscriptionRequestModelConverter();

  @override
  CreateTranscriptionRequestModel fromJson(Object? data) {
    if (data is String &&
        _$CreateTranscriptionRequestModelEnumEnumMap.values.contains(data)) {
      return CreateTranscriptionRequestModelEnumeration(
        _$CreateTranscriptionRequestModelEnumEnumMap.keys.elementAt(
          _$CreateTranscriptionRequestModelEnumEnumMap.values
              .toList()
              .indexOf(data),
        ),
      );
    }
    if (data is String) {
      return CreateTranscriptionRequestModelString(data);
    }
    throw Exception(
      'Unexpected value for CreateTranscriptionRequestModel: $data',
    );
  }

  @override
  Object? toJson(CreateTranscriptionRequestModel data) {
    return switch (data) {
      CreateTranscriptionRequestModelEnumeration(value: final v) =>
        _$CreateTranscriptionRequestModelEnumEnumMap[v]!,
      CreateTranscriptionRequestModelString(value: final v) => v,
    };
  }
}

// ==========================================
// ENUM: CreateTranscriptionRequestResponseFormat
// ==========================================

/// The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
enum CreateTranscriptionRequestResponseFormat {
  @JsonValue('json')
  json,
  @JsonValue('text')
  text,
  @JsonValue('srt')
  srt,
  @JsonValue('verbose_json')
  verboseJson,
  @JsonValue('vtt')
  vtt,
}
