import 'package:dokandar_shop/common/models/response_model.dart';
import 'package:dokandar_shop/features/coupon/domain/models/coupon_body_model.dart';

abstract class CouponServiceInterface {
  Future<ResponseModel> addCoupon(Map<String, String?> data);
  Future<ResponseModel> updateCoupon(Map<String, String?> body);
  Future<List<CouponBodyModel>?> getCouponList(int offset);
  Future<CouponBodyModel?> getCouponDetails(int id);
  Future<bool> changeStatus(int? couponId, int status);
  Future<ResponseModel> deleteCoupon(int? couponId);
}