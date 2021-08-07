include ../../credential.env
include ../service.mk
include ../accounts.mk

done:
	@clickhouse-client -d "$(DB)" -q "SELECT biddingScheme_type, count(*) FROM BiddingStrategy GROUP BY biddingScheme_type FORMAT PrettyCompactNoEscapes"
