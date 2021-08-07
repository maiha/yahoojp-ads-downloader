include ../../credential.env
include ../service.mk
include ../accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT userStatus, count(*) FROM AdGroup GROUP BY userStatus FORMAT PrettyCompactNoEscapes"
