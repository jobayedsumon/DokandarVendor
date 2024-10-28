import 'package:dokandar_shop/interface/repository_interface.dart';

abstract class HtmlRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getHtmlText(bool isPrivacyPolicy);
}