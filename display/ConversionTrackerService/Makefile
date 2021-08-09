include ../const.env
include ../../credential.env
include ../../lib/service.mk
include ../../lib/accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT conversionTrackerType, count(*) FROM ConversionTracker GROUP BY conversionTrackerType FORMAT PrettyCompactNoEscapes"
