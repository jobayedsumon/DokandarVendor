import 'package:get/get.dart';
import 'package:dokandar_shop/api/api_client.dart';
import 'package:dokandar_shop/features/html/domain/repositories/html_repository_interface.dart';
import 'package:dokandar_shop/features/language/controllers/language_controller.dart';
import 'package:dokandar_shop/util/app_constants.dart';

class HtmlRepository implements HtmlRepositoryInterface {
  final ApiClient apiClient;
  HtmlRepository({required this.apiClient});

  @override
  Future<Response> getHtmlText(bool isPrivacyPolicy) async {
    return await apiClient.getData(
      isPrivacyPolicy ? AppConstants.privacyPolicyUri : AppConstants.termsAndConditionsUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        AppConstants.moduleId: '',
        AppConstants.localizationKey: Get.find<LocalizationController>().locale.languageCode,
      },
    );
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}