include ../../credential.env
include ../service.mk
include ../accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT conversionTrackerType, count(*) FROM ConversionTracker GROUP BY conversionTrackerType FORMAT PrettyCompactNoEscapes"
