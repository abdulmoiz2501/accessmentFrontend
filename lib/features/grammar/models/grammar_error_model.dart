class GrammarErrorModel {
  final String word;
  final int startIndex;
  final int endIndex;
  final String message;
  final List<String> suggestions;

  GrammarErrorModel({
    required this.word,
    required this.startIndex,
    required this.endIndex,
    required this.message,
    required this.suggestions,
  });

  factory GrammarErrorModel.fromJson(Map<String, dynamic> json) {
    return GrammarErrorModel(
      word: json['word'] ?? '',
      startIndex: json['startIndex'] ?? 0,
      endIndex: json['endIndex'] ?? 0,
      message: json['message'] ?? '',
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'startIndex': startIndex,
      'endIndex': endIndex,
      'message': message,
      'suggestions': suggestions,
    };
  }
}

