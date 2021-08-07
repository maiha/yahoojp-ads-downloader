CREATE TABLE IF NOT EXISTS AdGroup (
  accountId  Int64,
  adGroupAdRotationMode_adRotationMode  String,
  adGroupId  Int64,
  adGroupName  String,
  adGroupTrackId  Int64,
  bid_bidSource  String,
  bid_maxCpc  Int64,
  campaignId  Int64,
  campaignName  String,
  campaignTrackId  Int64,
  createdDate  String,
  settings_criterionType  String,
  settings_targetingSetting_targetAll  String,
  targetCpaOverride  Int64,
  trackingUrl  String,
  urlReviewData_urlApprovalStatus  String,
  userStatus  String
) Engine = Log
