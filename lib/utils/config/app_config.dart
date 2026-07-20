import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:logger/logger.dart';
import 'package:weather_app/share/model/language_model.dart';

class AppConfig {
  //API Base URL
  // static const String baseURL = "http://10.10.20.52:5002/api";
  static const String baseURL = "https://api.sitenorm.com/api/v1";
  // static const String baseURL = "https://nc5cnwcx-5000.inc1.devtunnels.ms/api/v1";
  static const String fontFamily = "Urbanist";
  static const String googleMapKey = "AIzaSyAFkrO5JzbDTL0IGb-ObLLKDgjY5BuGZG8";
  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: false,
      printEmojis: true,
    ),
  );

  //Default Language Key
  static const String defaultLanguageKey = "en";

  static const defaultProfile =
      "https://img.freepik.com/premium-photo/casual-young-man-shirt_146377-2992.jpg";
  static List<LanguageModel> languages = [
    // LanguageModel(imageUrl: "", languageName: 'german'.tr, countryCode: 'DE', languageCode: 'de'),
    LanguageModel(
      imageUrl: "",
      languageName: 'english'.tr,
      countryCode: 'US',
      languageCode: 'en',
    ),
  ];
}
