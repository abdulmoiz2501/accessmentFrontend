import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../controllers/grammar_controller.dart';
import '../models/grammar_error_model.dart';

class SuggestionBottomSheet extends StatelessWidget {
  final GrammarErrorModel error;

  const SuggestionBottomSheet({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final GrammarController controller = Get.find<GrammarController>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Error word
          Text(
            'Error: "${error.word}"',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),

          // Error message
          if (error.message.isNotEmpty) ...[
            Text(
              error.message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Suggestions
          if (error.suggestions.isNotEmpty) ...[
            const Text(
              'Suggestions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ...error.suggestions.map((suggestion) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      controller.applySuggestion(suggestion);
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              suggestion,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ] else ...[
            const Text(
              'No suggestions available',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Close button
          CustomElevatedButton(
            text: 'Close',
            onPressed: () => Get.back(),
            backgroundColor: AppColors.textGrey,
          ),
        ],
      ),
    );
  }
}

