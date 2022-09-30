include ../const.env
include ../../credential.env
include ../../lib/service.mk
include ../../lib/accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT count(*) FROM $(TABLE) FORMAT PrettyCompactNoEscapes"
