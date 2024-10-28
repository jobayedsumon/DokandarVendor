import 'package:dokandar_shop/api/api_client.dart';
import 'package:dokandar_shop/features/order/domain/models/update_status_body_model.dart';
import 'package:dokandar_shop/interface/repository_interface.dart';

abstract class OrderRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getPaginatedOrderList(int offset, String status);
  Future<dynamic> updateOrderStatus(UpdateStatusBodyModel updateStatusBody, List<MultipartBody> proofAttachment);
  Future<dynamic> getOrderDetails(int orderID);
  Future<dynamic> getCancelReasons();
  Future<dynamic> sendDeliveredNotification(int? orderID);
}