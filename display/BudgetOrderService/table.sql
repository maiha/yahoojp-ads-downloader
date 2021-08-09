CREATE TABLE IF NOT EXISTS BudgetOrder (
  accountId Int64,
  accountType String,
  amount Int64,
  limitChargeType String
) Engine = Log
