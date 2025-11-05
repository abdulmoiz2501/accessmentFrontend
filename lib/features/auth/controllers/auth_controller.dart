import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/constants/api.dart';
import '../../../../core/widgets/toast.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final UserService _userService = Get.find<UserService>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showPassword = false.obs;

  // Login
  Future<bool> login(String username, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Attempting login to: ${Api.baseUrl}${Api.login}');
      print('Username: $username');
      
      final response = await _apiService.post(
        Api.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'] ?? '';
        final userData = data['user'] ?? {};

        final user = UserModel.fromJson(userData);
        await _userService.setUser(user, token);

        Toast.showSuccess('Login successful');
        isLoading.value = false;
        return true;
      } else {
        final data = response.data;
        errorMessage.value = data['message'] ?? 'Login failed';
        print('Login error: ${errorMessage.value}');
        Toast.showError(errorMessage.value);
        isLoading.value = false;
        return false;
      }
    } on DioException catch (e) {
      // Handle DioException (network errors, HTTP errors)
      String message = 'Failed to login. Please try again.';
      
      if (e.response != null) {
        // Server responded with error status
        final data = e.response?.data;
        if (data is Map) {
          // Handle both 'message' and 'error' fields
          if (data.containsKey('message')) {
            message = data['message'] ?? message;
          } else if (data.containsKey('error')) {
            message = data['error'] ?? message;
          } else {
            message = 'Login failed: ${e.response?.statusCode}';
          }
        } else {
          message = 'Login failed: ${e.response?.statusCode}';
        }
        print('Login DioException: ${e.response?.statusCode} - Response: $data');
        print('Login error message: $message');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timeout. Please check your internet connection.';
        print('Login timeout: $e');
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Unable to connect to server. Please check your internet connection.';
        print('Login connection error: $e');
      } else {
        print('Login DioException: $e');
      }
      
      errorMessage.value = message;
      Toast.showError(message);
      isLoading.value = false;
      return false;
    } catch (e) {
      // Handle other exceptions
      errorMessage.value = 'Failed to login. Please try again.';
      print('Login exception: $e');
      Toast.showError(errorMessage.value);
      isLoading.value = false;
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _apiService.post(Api.logout);
      await _userService.logout();
      Toast.showSuccess('Logged out successfully');
      isLoading.value = false;
    } catch (e) {
      // Even if API call fails, logout locally
      await _userService.logout();
      isLoading.value = false;
    }
  }
}

