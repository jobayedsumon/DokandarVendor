import 'package:image_picker/image_picker.dart';
import 'package:dokandar_shop/features/profile/domain/models/profile_model.dart';
import 'package:dokandar_shop/interface/repository_interface.dart';

abstract class ProfileRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getProfileInfo();
  Future<dynamic> updateProfile(ProfileModel userInfoModel, XFile? data, String token);
  Future<dynamic> deleteVendor();
  updateHeader(int? moduleID);
}