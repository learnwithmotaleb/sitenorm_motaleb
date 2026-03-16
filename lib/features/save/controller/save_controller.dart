import 'package:get/get.dart';
import 'package:weather_app/core/di/injection.dart';
import 'package:weather_app/core/service/datasource/remote/api_client.dart';
import 'package:weather_app/features/save/model/save_details_model.dart';
import 'package:weather_app/features/save/model/saved_model.dart';
import 'package:weather_app/utils/api_urls/api_urls.dart';
import 'package:weather_app/utils/config/app_config.dart';

class SaveController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();

  final RxBool isLoading = false.obs;
  final Rx<SavedModel> savedModel = SavedModel().obs;

  @override
  void onInit() {
    super.onInit();
    getSavedStations();
  }

  Future<void> getSavedStations() async {
    isLoading.value = true;
    try {
      final response = await apiClient.get(url: ApiUrls.getSavedStations());
      if (response.statusCode == 200 || response.statusCode == 201) {
        savedModel.value = SavedModel.fromJson(response.data);

      } else {
        AppConfig.logger.e("Failed to load saved stations: ${response.data}");
      }
    } catch (e) {
      AppConfig.logger.e(e.toString());
    } finally {
      isLoading.value = false;
    }
  } 
 
 Rx<SaveDetailsModel> saveDetailsModel = SaveDetailsModel().obs;
  Future<void> getSaveDetails({required String id}) async {
    isLoading.value = true;
    try {
      final response = await apiClient.get(url: ApiUrls.getSaveDetails( id: id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        saveDetailsModel.value = SaveDetailsModel.fromJson(response.data);
      } else {
        AppConfig.logger.e("Failed to load save details: ${response.data}");
      }
    } catch (e) {
      AppConfig.logger.e(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
