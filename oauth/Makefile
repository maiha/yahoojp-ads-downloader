include ../credential.env

OAUTH_URL    = https://biz-oauth.yahoo.co.jp
REDIRECT_URI = https://yahoojp-marketing.github.io/ads-display-api-documents/oauth2-redirect.html

all: usage

usage:
	# https://ads-developers.yahoo.co.jp/developercenter/ja/startup-guide/api-call.html
	# make authorize     # Get the authorization from the application user
	# make authenticate  # Send a request to the authorization API
	# make token         # Update the access token if it has expired.

clean:
	rm -f token.*

authorize:
	: # authorize
	@echo "$(OAUTH_URL)/oauth/v1/authorize?response_type=code&client_id=$(CLIENT_ID)&redirect_uri=$(REDIRECT_URI)&scope=yahooads&state=$(STATE)"

authenticate:
	: # generate access_token
	@curl -D "$@.header" "$(OAUTH_URL)/oauth/v1/token?grant_type=authorization_code&client_id=$(CLIENT_ID)&client_secret=$(CLIENT_SECRET)&redirect_uri=$(REDIRECT_URI)&code=$(AUTH_CODE)" > "$@.json"


token: expire token.json

expire:
	@find . -maxdepth 1 -mmin +50 -name token.json | xargs -r rm

token.json:
	: # regenerate access_token
	@curl -s -D token.header "$(OAUTH_URL)/oauth/v1/token?grant_type=refresh_token&client_id=$(CLIENT_ID)&client_secret=$(CLIENT_SECRET)&refresh_token=$(REFRESH_TOKEN)" > "$@.tmp"
	@grep access_token "$@.tmp" > /dev/null
	@mv "$@.tmp" "$@"
