import 'package:image_picker/image_picker.dart';
import 'package:dokandar_shop/interface/repository_interface.dart';

abstract class BannerRepositoryInterface extends RepositoryInterface {
  Future<dynamic> addBanner(String title, String url, XFile image);
  Future<dynamic> updateBanner(int? bannerID, String title, String url, XFile? image);
}