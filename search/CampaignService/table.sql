CREATE TABLE IF NOT EXISTS Campaign (
  accountId  Int64,
  appId  String,
  appStore  String,
  biddingStrategyConfiguration_biddingScheme_biddingStrategyType  String,
  biddingStrategyConfiguration_biddingScheme_manualCpcBiddingScheme_enhancedCpcEnabled  String,
  biddingStrategyConfiguration_biddingScheme_targetCpaBiddingScheme_bidCeiling  Int64,
  biddingStrategyConfiguration_biddingScheme_targetCpaBiddingScheme_bidFloor  Int64,
  biddingStrategyConfiguration_biddingScheme_targetCpaBiddingScheme_targetCpa  Int64,
  biddingStrategyConfiguration_biddingScheme_targetImpressionShareScheme_bidCeiling  Int64,
  biddingStrategyConfiguration_biddingScheme_targetImpressionShareScheme_location  String,
  biddingStrategyConfiguration_biddingScheme_targetImpressionShareScheme_targetImpressionShare  Int64,
  biddingStrategyConfiguration_biddingScheme_targetSpendBiddingScheme_bidCeiling  Int64,
  biddingStrategyConfiguration_biddingStrategyId  Int64,
  biddingStrategyConfiguration_biddingStrategyName  String,
  biddingStrategyConfiguration_biddingStrategySource  String,
  budget_amount  Int64,
  budget_budgetPeriod  String,
  campaignId  Int64,
  campaignName  String,
  campaignTrackId  Int64,
  conversionOptimizerEligibility  String,
  createdDate  String,
  endDate  String,
  servingStatus  String,
  settings_0_dynamicAdsForSearchSetting_dasUseUrlsType  String,
  settings_0_dynamicAdsForSearchSetting_domain  String,
  settings_0_dynamicAdsForSearchSetting_feedIds_0  Int64,
  settings_0_geoTargetTypeSetting_negativeGeoTargetType  String,
  settings_0_geoTargetTypeSetting_positiveGeoTargetType  String,
  settings_0_settingType  String,
  settings_1_geoTargetTypeSetting_negativeGeoTargetType  String,
  settings_1_geoTargetTypeSetting_positiveGeoTargetType  String,
  settings_1_settingType  String,
  settings_1_targetingSetting_targetAll  String,
  settings_2_settingType  String,
  settings_2_targetingSetting_targetAll  String,
  startDate  String,
  trackingUrl  String,
  type  String,
  urlReviewData_urlApprovalStatus  String,
  userStatus  String
) Engine = Log
