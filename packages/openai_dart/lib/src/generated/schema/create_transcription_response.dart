// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: invalid_annotation_target
part of open_a_i_schema;

// ==========================================
// CLASS: CreateTranscriptionResponse
// ==========================================

/// No Description
@freezed
class CreateTranscriptionResponse with _$CreateTranscriptionResponse {
  const CreateTranscriptionResponse._();

  /// Factory constructor for CreateTranscriptionResponse
  const factory CreateTranscriptionResponse({
    /// No Description
    required String text,
  }) = _CreateTranscriptionResponse;

  /// Object construction from a JSON representation
  factory CreateTranscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateTranscriptionResponseFromJson(json);

  /// List of all property names of schema
  static const List<String> propertyNames = ['text'];

  /// Perform validations on the schema property values
  String? validateSchema() {
    return null;
  }

  /// Map representation of object (not serialized)
  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }
}
