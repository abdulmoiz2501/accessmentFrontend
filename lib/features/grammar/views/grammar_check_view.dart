import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../features/auth/controllers/auth_controller.dart';
import '../controllers/grammar_controller.dart';
import '../widgets/grammar_text_preview.dart';
import '../widgets/suggestion_bottom_sheet.dart';

class GrammarCheckView extends StatefulWidget {
  const GrammarCheckView({super.key});

  @override
  State<GrammarCheckView> createState() => _GrammarCheckViewState();
}

class _GrammarCheckViewState extends State<GrammarCheckView> {
  late TextEditingController inputController;
  late GrammarController grammarController;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    grammarController = Get.isRegistered<GrammarController>()
        ? Get.find<GrammarController>()
        : Get.put(GrammarController());
    authController = Get.isRegistered()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
    inputController = TextEditingController();

    // Sync controller with text field - uses debounced method
    inputController.addListener(() {
      grammarController.updateInputText(inputController.text);
    });

    // Sync text field with controller when suggestion is applied
    ever(grammarController.inputText, (String text) {
      if (inputController.text != text) {
        inputController.text = text;
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Grammar Check',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textDark),
            onPressed: () async {
              await authController.logout();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Output Preview
                const Text(
                  'Output',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                GrammarTextPreview(
                  text: grammarController.inputText.value.isEmpty
                      ? ''
                      : grammarController.inputText.value,
                  errors: grammarController.errors,
                  onErrorTap: (error) {
                    grammarController.selectedError.value = error;
                    Get.bottomSheet(
                      SuggestionBottomSheet(error: error),
                      isScrollControlled: true,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Loading indicator
                if (grammarController.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),

                // Input Field
                const Text(
                  'Input',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: "User's plain text input goes here.",
                  controller: inputController,
                  maxLines: 10,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),

                // Test OpenAI API button
                OutlinedButton(
                  onPressed: grammarController.isLoading.value
                      ? null
                      : () async {
                          final success = await grammarController.testOpenAI();
                          if (success) {
                            Toast.showSuccess('OpenAI API test successful!');
                          } else {
                            Toast.showError(
                                'OpenAI API test failed: ${grammarController.errorMessage.value}');
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: AppColors.success),
                  ),
                  child: Obx(
                    () => Text(
                      grammarController.isLoading.value
                          ? 'Testing...'
                          : 'Test OpenAI API',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Clear button
                if (grammarController.inputText.value.isNotEmpty)
                  OutlinedButton(
                    onPressed: () {
                      inputController.clear();
                      grammarController.inputText.value = '';
                      grammarController.clearAll();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

