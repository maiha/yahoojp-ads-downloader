CREATE TABLE IF NOT EXISTS GeographicLocation (
  child  Int64,
  code  String,
  fullName  String,
  geographicLocationStatus  String,
  name  String,
  order  String,
  parent  String
) Engine = Log
