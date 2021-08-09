# Yahoo! JAPAN Ads Downloader

Call the API of Yahoo! JAPAN Ads and import the data into the DB(ClickHouse).

* Search Ads API  : https://ads-developers.yahoo.co.jp/reference/ads-search-api/v5/
* Display Ads API : https://ads-developers.yahoo.co.jp/reference/ads-display-api/v5/

#### requirements
* GNU Make
* jq
* curl

## credentials

Put your crendentials into `credential.env`

```bash
CLIENT_ID=...
CLIENT_SECRET=...
REFRESH_TOKEN=...
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
