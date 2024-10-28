import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dokandar_shop/interface/repository_interface.dart';

abstract class AddressRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getAddressFromGeocode(LatLng latLng);
  Future<dynamic> searchLocation(String text);
  Future<dynamic> getPlaceDetails(String? placeID);
  Future<dynamic> getZone(String lat, String lng);
  Future<bool> saveUserAddress(String address, List<int>? zoneIDs);
  String? getUserAddress();
  Future<dynamic> getModules(int? zoneId);
}