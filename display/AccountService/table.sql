CREATE TABLE IF NOT EXISTS Account (
  accountId Int64,
  accountName String,
  accountStatus String,
  accountType String,
  authType String,
  autoTaggingEnabled String,
  deliveryStatus String,
  isTestAccount String,
  startDate String,
  endDate String,
  isManagerAccount String,
  contactBizId String
) Engine = Log
