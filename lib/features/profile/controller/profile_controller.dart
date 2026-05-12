import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/router/route_path.dart';
import 'package:weather_app/core/router/routes.dart';
import 'package:weather_app/core/service/datasource/local/local_service.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/features/profile/model/profile_model.dart';
import 'package:weather_app/helper/toast/toast_helper.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/utils/config/app_config.dart';
import 'package:weather_app/utils/multipart/multipart_body.dart';

class ProfileController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  Rx<XFile?> selectedImage = Rx<XFile?>(null);

  Future<void> pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      selectedImage.value = image;
    }
  }

  final profileLoading = false.obs;
  bool loadingProdileMethod(bool status) => profileLoading.value = status;
  final Rx<ProfileModel> profile = ProfileModel().obs;
  Future<void> getProfile() async {
    AppConfig.logger.i("Get Profile Method Called");
    loadingProdileMethod(true);
    try {
      final response = await apiClient.get(
        url: ApiUrls.getProfile(),
        token: await localService.getToken(),
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        final newData = ProfileModel.fromJson(response.data);
        profile.value = newData;
        loadingProdileMethod(false);
      }
    } catch (e) {
      loadingProdileMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  // update profile

  final updateProfileLoading = false.obs;
  bool loadingUpdateProfileMethod(bool status) =>
      updateProfileLoading.value = status;
  Future<void> updateProfile({required Map<String, String> body}) async {
    loadingUpdateProfileMethod(true);
    final token = await localService.getToken();
    try {
      if (selectedImage.value != null && selectedImage.value!.path.isNotEmpty) {
        List<MultipartBody> multipartBody = [
          MultipartBody(
            fieldKey: "avatar",
            file: File(selectedImage.value!.path),
          ),
        ];
        final avatarResponse = await apiClient.uploadMultipart(
          url: ApiUrls.updateAvatar(),
          files: multipartBody,
          method: "PUT",
          token: token,
        );
        AppConfig.logger.i("Avatar update response: ${avatarResponse.data}");
        if (avatarResponse.statusCode != 200) {
          loadingUpdateProfileMethod(false);
          AppToast.error(message: avatarResponse.data["message"].toString());
          return;
        }
      }

      final response = await apiClient.put(
        url: ApiUrls.editProfile(),
        token: token,
        body: body,
      );

      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        await getProfile();
        loadingUpdateProfileMethod(false);
        AppToast.success(message: response.data["message"].toString());
        AppRouter.route.pop();
        return;
      } else {
        loadingUpdateProfileMethod(false);
        AppToast.error(message: response.data["message"].toString());
      }
    } catch (e) {
      loadingUpdateProfileMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  // logout

  final logoutLoading = false.obs;
  bool loadingLogoutMethod(bool status) => logoutLoading.value = status;
  Future<void> logout() async {
    loadingLogoutMethod(true);
    try {
      final response = await apiClient.post(url: ApiUrls.logout(), body: {});
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        await localService.logOut();
        loadingLogoutMethod(false);
        AppToast.success(message: response.data["message"].toString());
        AppRouter.route.goNamed(RoutePath.loginScreen);
      } else {
        loadingLogoutMethod(false);
      }
    } catch (e) {
      loadingLogoutMethod(false);
      AppConfig.logger.e(e.toString());
    }
  }

  // delete account

  final deleteAccountLoading = false.obs;
  bool loadingDeleteAccountMethod(bool status) =>
      deleteAccountLoading.value = status;
  Future<void> deleteAccount() async {
    loadingDeleteAccountMethod(true);
    try {
      final response = await apiClient.delete(
        url: ApiUrls.deleteAccount(),
        token: await localService.getToken(),
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        await localService.logOut();
        loadingDeleteAccountMethod(false);
        AppToast.success(
          message:
              response.data?["message"]?.toString() ??
              "Account deleted successfully",
        );
        AppRouter.route.goNamed(RoutePath.loginScreen);
      } else {
        loadingDeleteAccountMethod(false);
        AppToast.error(
          message:
              response.data?["message"]?.toString() ??
              "Failed to delete account",
        );
      }
    } catch (e) {
      loadingDeleteAccountMethod(false);
      AppConfig.logger.e(e.toString());
      AppToast.error(message: "Something went wrong");
    }
  }
}
