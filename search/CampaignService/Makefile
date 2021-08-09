include ../const.env
include ../../credential.env
include ../../lib/service.mk
include ../../lib/accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT createdDate, count(*) FROM Campaign GROUP BY createdDate ORDER BY createdDate DESC limit 3 FORMAT PrettyCompactNoEscapes"
