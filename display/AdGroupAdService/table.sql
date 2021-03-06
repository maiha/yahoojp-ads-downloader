CREATE TABLE IF NOT EXISTS AdGroupAd (
  accountId Int64,
  adGroupId Int64,
  adGroupName String,
  adId Int64,
  adName String,
  adStyle String,
  ad_adType String,
  ad_bannerImageAd_displayUrl String,
  ad_bannerImageAd_url String,
  ad_bannerVideoAd_displayUrl String,
  ad_bannerVideoAd_thumbnailMediaId Int64,
  ad_bannerVideoAd_url String,
  ad_responsiveImageAd_buttonText String,
  ad_responsiveImageAd_description String,
  ad_responsiveImageAd_displayUrl String,
  ad_responsiveImageAd_headline String,
  ad_responsiveImageAd_logoMediaId Int64,
  ad_responsiveImageAd_principal String,
  ad_responsiveImageAd_url String,
  ad_responsiveVideoAd_buttonText String,
  ad_responsiveVideoAd_description String,
  ad_responsiveVideoAd_displayUrl String,
  ad_responsiveVideoAd_headline String,
  ad_responsiveVideoAd_logoMediaId Int64,
  ad_responsiveVideoAd_principal String,
  ad_responsiveVideoAd_thumbnailMediaId Int64,
  ad_responsiveVideoAd_url String,
  ad_responsiveVideoAd_video50PercentBeaconUrls_0 String,
  ad_responsiveVideoAd_videoCompleteBeaconUrls_0 String,
  ad_textAd_description String,
  ad_textAd_description2 String,
  ad_textAd_displayUrl String,
  ad_textAd_headline String,
  ad_textAd_url String,
  approvalStatus String,
  campaignId Int64,
  campaignName String,
  createdDate String,
  disapprovalReasonCodes_0 String,
  disapprovalReasonDescription String,
  impressionBeaconUrls_0 String,
  impressionBeaconUrls_1 String,
  mediaId Int64,
  thirdPartyTrackingScriptUrl String,
  thirdPartyTrackingVendor String,
  userStatus String
) Engine = Log
