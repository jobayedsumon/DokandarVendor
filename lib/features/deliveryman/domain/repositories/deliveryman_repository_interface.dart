import 'package:dokandar_shop/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dokandar_shop/features/deliveryman/domain/models/delivery_man_model.dart';

abstract class DeliverymanRepositoryInterface implements RepositoryInterface {
  Future<dynamic> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd);
  Future<dynamic> updateDeliveryManStatus(int? deliveryManID, int status);
}