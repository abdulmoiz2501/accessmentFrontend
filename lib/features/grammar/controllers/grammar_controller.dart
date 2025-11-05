import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api.dart';
import '../../../../core/widgets/toast.dart';
import '../models/grammar_check_response_model.dart';
import '../models/grammar_error_model.dart';

class GrammarController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxString inputText = ''.obs;
  final RxString correctedText = ''.obs;
  final RxList<GrammarErrorModel> errors = <GrammarErrorModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<GrammarErrorModel?> selectedError = Rx<GrammarErrorModel?>(null);

  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 1500); // 1.5 seconds after user stops typing

  // Check grammar
  Future<void> checkGrammar(String text) async {
    if (text.trim().isEmpty) {
      correctedText.value = '';
      errors.clear();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      correctedText.value = text; // Show input initially

      final response = await _apiService.post(
        Api.grammarCheck,
        data: {
          'text': text,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final grammarResponse = GrammarCheckResponseModel.fromJson(data);

        correctedText.value = grammarResponse.correctedText;
        errors.value = grammarResponse.errors;
      } else {
        final data = response.data;
        print('Grammar check error: $data');
        errorMessage.value = data['message'] ?? 'Failed to check grammar';
        Toast.showError(errorMessage.value);
        correctedText.value = text;
        errors.clear();
      }
    } catch (e) {
      print('Grammar check exception: $e');
      errorMessage.value = 'Failed to check grammar. Please try again.';
      Toast.showError(errorMessage.value);
      // Keep showing input text even on error
      correctedText.value = text;
      errors.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }

  // Update input text and check grammar with debouncing
  void updateInputText(String text) {
    inputText.value = text;
    
    // Cancel previous timer if exists
    _debounceTimer?.cancel();
    
    // Clear errors immediately when text is cleared
    if (text.trim().isEmpty) {
      correctedText.value = '';
      errors.clear();
      return;
    }
    
    // Set new timer for debounced check
    _debounceTimer = Timer(_debounceDelay, () {
      // Only check if text hasn't changed during the delay
      if (inputText.value == text && text.trim().isNotEmpty) {
        checkGrammar(text);
      }
    });
  }

  // Apply suggestion - returns the new text
  String applySuggestion(String suggestion) {
    if (selectedError.value == null) return inputText.value;

    final error = selectedError.value!;
    final currentText = inputText.value;
    final newText = currentText.substring(0, error.startIndex) +
        suggestion +
        currentText.substring(error.endIndex);

    inputText.value = newText;
    checkGrammar(newText);
    selectedError.value = null;
    return newText;
  }

  // Clear all
  void clearAll() {
    _debounceTimer?.cancel();
    inputText.value = '';
    correctedText.value = '';
    errors.clear();
    selectedError.value = null;
    errorMessage.value = '';
  }

  // Test OpenAI API connection
  Future<bool> testOpenAI() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final testText = 'This is a test sentense for gramer checking.';
      
      final response = await _apiService.post(
        Api.grammarCheck,
        data: {
          'text': testText,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final grammarResponse = GrammarCheckResponseModel.fromJson(data);
        
        print('OpenAI API Test - Success!');
        print('Original: $testText');
        print('Corrected: ${grammarResponse.correctedText}');
        print('Errors found: ${grammarResponse.errors.length}');
        
        isLoading.value = false;
        return true;
      } else {
        final data = response.data;
        errorMessage.value = data['message'] ?? 'Test failed';
        print('OpenAI API Test - Error: ${errorMessage.value}');
        isLoading.value = false;
        return false;
      }
    } on DioException catch (e) {
      String message = 'OpenAI API test failed';
      
      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map) {
          message = data['message'] ?? data['error'] ?? message;
        }
      }
      
      errorMessage.value = message;
      print('OpenAI API Test - DioException: $message');
      isLoading.value = false;
      return false;
    } catch (e) {
      errorMessage.value = 'OpenAI API test failed: $e';
      print('OpenAI API Test - Exception: $e');
      isLoading.value = false;
      return false;
    }
  }
}

