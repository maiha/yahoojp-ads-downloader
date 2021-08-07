include ../../credential.env
include ../service.mk

usage:
	# make recv      # call API and store as res.json
	# make data      # create data.jsonl from res.json
	# make db        # insert into ClickHouse
	# make run       # execute all above tasks

######################################################################
### Action

run:
	$(MAKE) recv
	$(MAKE) data
	$(MAKE) db
	@$(MAKE) done

recv: req.json
	$(call api,get,req.json,res.json)

done:
	@clickhouse-client -d "$(DB)" -q "SELECT accountType, count(*) FROM Account GROUP BY accountType limit 3 FORMAT PrettyCompactNoEscapes"

######################################################################
### Low rules

ACCOUNT_IDS=$(shell jq -r '.rval.values[].account | select(.accountStatus == "SERVING") | .accountId' $(ACCOUNTS_JSON) | xargs -r echo | tr ' ' ',')

.PHONY : req.json
req.json: $(ACCOUNTS_JSON)
	jq ".accountIds = [$(ACCOUNT_IDS)]" "$@" > "$@.tmp"
	mv "$@.tmp" "$@"

data: res.json
	jq -c '.rval.values[] | select(.operationSucceeded == true) | .budgetOrder' res.json > "data.jsonl.err"
	mv "data.jsonl.err" "data.jsonl"
