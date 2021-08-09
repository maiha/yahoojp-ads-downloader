include ../const.env
include ../../credential.env
include ../../lib/service.mk
include ../../lib/accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT biddingScheme_type, count(*) FROM BiddingStrategy GROUP BY biddingScheme_type FORMAT PrettyCompactNoEscapes"
