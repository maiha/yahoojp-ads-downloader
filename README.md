# Yahoo! JAPAN Ads Downloader

Call the API of Yahoo! JAPAN Ads and import the data into the DB(ClickHouse).

* Search Ads API  : https://ads-developers.yahoo.co.jp/reference/ads-search-api/v14/
* Display Ads API : https://ads-developers.yahoo.co.jp/reference/ads-display-api/v14/

#### requirements
* GNU Make
* jq
* curl
* nkf (only if oauth/authorize)

## credentials

Put your crendentials into `credential.env`

```bash
CLIENT_ID=...
CLIENT_SECRET=...
REFRESH_TOKEN=...
AUTH_CODE=...     # only if oauth/authenticate
```

## tasks

```console
make recv      # call API and store as res.json
make data      # convert res.json to data.jsonl
make db        # insert data.jsonl into ClickHouse

make run       # execute all above tasks
```

## usage

First, you need to call AccountService to gather all the account IDs.
Next, run the service you want to get.

If you don't need to update the DB and just want to execute the API, execute `recv` instead of `run`.

## Search Ads

```console
make run -C search/AccountService
make run -C search/AdGroupAdService
make run -C search/AdGroupService
make run -C search/BiddingStrategyService
make run -C search/BudgetOrderService
make run -C search/CampaignService
make run -C search/ConversionTrackerService
make run -C search/DictionaryService
```

## Display Ads

```console
make run -C display/AccountService
make run -C display/AdGroupAdService
make run -C display/AdGroupService
make run -C display/BudgetOrderService
make run -C display/CampaignService
make run -C display/ConversionTrackerService
make run -C display/StatsService
make run -C display/VideoService
```

## OAuth

https://ads-developers.yahoo.co.jp/developercenter/en/startup-guide/api-call.html

### Authorize application

* put 'CLIENT_ID' and 'CLIENT_SECRET' into `credential.env`

```console
$ cd oauth

$ make authorize STATE=foo
# Open this url with your Business ID.
https://biz-oauth.yahoo.co.jp/oauth/v1/authorize?response_type=code&client_id=...&redirect_uri=...&scope=yahooads&state=foo

### or run with your REDIRECT_URI
$ make authorize STATE=foo REDIRECT_URI=http://localhost
# Open this url with your Business ID.
https://biz-oauth.yahoo.co.jp/oauth/v1/authorize?response_type=code&client_id=...&redirect_uri=http%3A%2F%2Flocalhost&scope=yahooads&state=foo
```

Check 'code=xxx` in the redirected url, and paste it in 'CODE=xxx'.

```console
$ make authenticate CODE=xxx
# Put this refresh_token into 'credential.env'.
{
  "access_token": "...",
  "expires_in": 3600,
  "token_type": "Bearer",
  "refresh_token": "..."
}
```
