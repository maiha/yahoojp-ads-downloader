include ../credential.env

OAUTH_URL    = https://biz-oauth.yahoo.co.jp
REDIRECT_URI = https://yahoojp-marketing.github.io/ads-search-api-documents/oauth2-redirect.html
E_REDIRECT_URI = $(shell jq -rn --arg x '$(REDIRECT_URI)' '$$x|@uri')

all: usage

usage:
	# https://ads-developers.yahoo.co.jp/developercenter/ja/startup-guide/api-call.html
	# make authorize     # Get the authorization from the application user (needs: STATE)
	# make authenticate  # Send a request to the authorization API
	# make token         # Update the access token if it has expired.
	#
	# vars:
	#   OAUTH_URL        = $(OAUTH_URL)
	#   CLIENT_ID        = $(CLIENT_ID)
	#   REDIRECT_URI     = $(REDIRECT_URI)
	#   E_REDIRECT_URI   = $(E_REDIRECT_URI)

clean:
	rm -f token.*

authorize:
ifndef STATE
	$(error STATE is not set)
endif
	@echo "# Open this url with your Business ID."
	@echo "$(OAUTH_URL)/oauth/v1/authorize?response_type=code&client_id=$(CLIENT_ID)&redirect_uri=$(E_REDIRECT_URI)&scope=yahooads&state=$(STATE)"

authenticate:
ifndef CODE
	$(error CODE is not set)
endif
	@echo "# Put this refresh_token into 'credential.env'."
	@curl -sS -D "$@.header" "$(OAUTH_URL)/oauth/v1/token?grant_type=authorization_code&client_id=$(CLIENT_ID)&client_secret=$(CLIENT_SECRET)&redirect_uri=$(E_REDIRECT_URI)&code=$(CODE)" | tee "$@.json" | jq .

token: expire token.json

expire:
	@find . -maxdepth 1 -mmin +50 -name token.json | xargs -r rm

token.json:
	: # regenerate access_token
	@curl -s -D token.header "$(OAUTH_URL)/oauth/v1/token?grant_type=refresh_token&client_id=$(CLIENT_ID)&client_secret=$(CLIENT_SECRET)&refresh_token=$(REFRESH_TOKEN)" > "$@.tmp"
	@grep access_token "$@.tmp" > /dev/null
	@mv "$@.tmp" "$@"
