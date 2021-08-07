CREATE TABLE IF NOT EXISTS BiddingStrategy (
  accountId  Int64,
  biddingScheme_targetCpaBiddingScheme_bidCeiling  Int64,
  biddingScheme_targetCpaBiddingScheme_bidFloor  Int64,
  biddingScheme_targetCpaBiddingScheme_targetCpa  Int64,
  biddingScheme_targetSpendBiddingScheme_bidCeiling  Int64,
  biddingScheme_type  String,
  biddingStrategyId  Int64,
  biddingStrategyName  String
) Engine = Log
