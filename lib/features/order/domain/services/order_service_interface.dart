import 'package:image_picker/image_picker.dart';
import 'package:dokandar_shop/api/api_client.dart';
import 'package:dokandar_shop/common/models/response_model.dart';
import 'package:dokandar_shop/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:dokandar_shop/features/order/domain/models/order_details_model.dart';
import 'package:dokandar_shop/features/order/domain/models/order_model.dart';
import 'package:dokandar_shop/features/order/domain/models/update_status_body_model.dart';

abstract class OrderServiceInterface {
  Future<List<OrderModel>?> getCurrentOrders();
  Future<PaginatedOrderModel?> getPaginatedOrderList(int offset, String status);
  Future<ResponseModel> updateOrderStatus(UpdateStatusBodyModel updateStatusBody, List<MultipartBody> proofAttachment);
  Future<List<OrderDetailsModel>?> getOrderDetails(int orderID);
  Future<OrderModel?> getOrderWithId(int orderId);
  Future<ResponseModel> updateOrderAmount(Map<String, String> body);
  Future<OrderCancellationBodyModel?> getCancelReasons();
  Future<bool> sendDeliveredNotification(int? orderID);
  List<MultipartBody> processMultipartData(List<XFile> pickedPrescriptions);
}