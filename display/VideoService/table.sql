CREATE TABLE IF NOT EXISTS Video (
  accountId Int64,
  approvalStatus String,
  createdDate String,
  creationTime String,
  disapprovalReasonCodes_0 String,
  mediaId Int64,
  processStatus String,
  userStatus String,
  videoName String,
  videoSetting_fileSize Int64,
  videoSetting_fileType String,
  videoSetting_height Int64,
  videoSetting_playbackTime Int64,
  videoSetting_videoAdFormat String,
  videoSetting_videoAspectRatio String,
  videoSetting_width Int64,
  videoTitle String
) Engine = Log
