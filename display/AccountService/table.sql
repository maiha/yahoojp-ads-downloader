CREATE TABLE IF NOT EXISTS Account (
  accountId  Int64,
  accountName  String,
  accountStatus  String,
  accountType  String,
  authType  String,
  autoTaggingEnabled  String,
  contactBizId  String,
  deliveryStatus  String,
  endDate  String,
  isManagerAccount  String,
  isTestAccount  String,
  startDate  String
) Engine = Log
