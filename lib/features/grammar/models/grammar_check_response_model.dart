import 'grammar_error_model.dart';

class GrammarCheckResponseModel {
  final String correctedText;
  final List<GrammarErrorModel> errors;

  GrammarCheckResponseModel({
    required this.correctedText,
    required this.errors,
  });

  factory GrammarCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return GrammarCheckResponseModel(
      correctedText: json['correctedText'] ?? '',
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => GrammarErrorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correctedText': correctedText,
      'errors': errors.map((e) => e.toJson()).toList(),
    };
  }
}

