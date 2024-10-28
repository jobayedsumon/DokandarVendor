import 'package:dokandar_shop/features/campaign/domain/models/campaign_model.dart';

abstract class CampaignServiceInterface {
  Future<List<CampaignModel>?> getCampaignList();
  Future<bool> joinCampaign(int? campaignID);
  Future<bool> leaveCampaign(int? campaignID);
  List<CampaignModel>? filterCampaign(String status, List<CampaignModel> allCampaignList);
}
