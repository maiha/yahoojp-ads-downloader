CREATE TABLE IF NOT EXISTS Media (
  accountId Int64,
  approvalStatus String,
  campaignBannerFlg String,
  creationTime String,
  disapprovalReasonCodes Array(String),
  logoFlg String,
  imageMedia String,
  mediaId Int64,
  mediaName String,
  mediaTitle String,
  thumbnailFlg String,
  userStatus String,
  mediaRichFormatFlg String,
  createdDate String
) Engine = Log
