include ../const.env
include ../../credential.env
include ../../lib/service.mk
include ../../lib/accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT approvalStatus, count(*) FROM $(TABLE) GROUP BY approvalStatus FORMAT PrettyCompactNoEscapes"
