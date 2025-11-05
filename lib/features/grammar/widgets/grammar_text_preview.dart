import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../models/grammar_error_model.dart';

class GrammarTextPreview extends StatelessWidget {
  final String text;
  final List<GrammarErrorModel> errors;
  final Function(GrammarErrorModel)? onErrorTap;

  const GrammarTextPreview({
    super.key,
    required this.text,
    required this.errors,
    this.onErrorTap,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text(
          'Output text goes here, with **incorrect** words highlighted as shown.',
          style: TextStyle(
            color: AppColors.textLightGrey,
            fontSize: 16,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: _buildTextWithErrors(text, errors, context),
    );
  }

  Widget _buildTextWithErrors(
    String text,
    List<GrammarErrorModel> errors,
    BuildContext context,
  ) {
    if (errors.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 16,
          height: 1.5,
        ),
      );
    }

    // Sort errors by start index
    final sortedErrors = List<GrammarErrorModel>.from(errors)
      ..sort((a, b) => a.startIndex.compareTo(b.startIndex));

    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final error in sortedErrors) {
      // Add text before error
      if (error.startIndex > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, error.startIndex),
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
            ),
          ),
        );
      }

      // Add error text with highlighting
      spans.add(
        TextSpan(
          text: text.substring(error.startIndex, error.endIndex),
          style: const TextStyle(
            color: AppColors.error,
            fontSize: 16,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.error,
            decorationThickness: 2,
            backgroundColor: AppColors.errorBackground,
            fontWeight: FontWeight.w500,
          ),
          recognizer: onErrorTap != null
              ? (TapGestureRecognizer()
                ..onTap = () => onErrorTap!(error))
              : null,
        ),
      );

      currentIndex = error.endIndex;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 16,
          height: 1.5,
        ),
        children: spans,
      ),
    );
  }
}

