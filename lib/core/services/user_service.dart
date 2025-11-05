import 'dart:convert';
import 'package:get/get.dart';
import '../../features/auth/models/user_model.dart';
import 'shared_prefs_service.dart';

class UserService extends GetxService {
  final SharedPrefsService _prefs = Get.find<SharedPrefsService>();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _prefs.getUserData();
    if (userData != null) {
      // Parse user data if needed
      final token = await _prefs.getToken();
      if (token != null && token.isNotEmpty) {
        isAuthenticated.value = true;
      }
    }
  }

  Future<void> setUser(UserModel user, String token) async {
    currentUser.value = user;
    await _prefs.saveToken(token);
    // Convert to JSON string
    final userJson = user.toJson();
    await _prefs.saveUserData(jsonEncode(userJson));
    isAuthenticated.value = true;
  }

  Future<void> logout() async {
    currentUser.value = null;
    await _prefs.removeToken();
    await _prefs.remove('user_data');
    isAuthenticated.value = false;
  }

  UserModel? get user => currentUser.value;
  bool get isLoggedIn => isAuthenticated.value;
}

