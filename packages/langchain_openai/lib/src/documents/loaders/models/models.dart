class OpenAIWhisperOptions {
  const OpenAIWhisperOptions({
    this.model = 'whisper-1',
    this.language,
    this.prompt,
    this.responseFormat,
    this.temperature,
  });

  /// The model to use when calling the Whisper API.
  final String model;

  /// The language of the input audio. Supplying the input language in [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) format will improve accuracy and latency.
  final String? language;

  /// An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text/prompting) should match the audio language.
  final String? prompt;

  /// The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
  final String? responseFormat;

  /// The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
  final double? temperature;
}
