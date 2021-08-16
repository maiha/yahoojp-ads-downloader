# Give priority to files in the current dir
ifeq (,$(wildcard map.jq))
MAP_JQ=../../lib/map.jq
else
MAP_JQ=map.jq
endif

usage:
	# SERVICE=$(SERVICE)
	# TABLE=$(TABLE)
	# TABLE_LC=$(TABLE_LC)
	# RECORD_KEY=$(RECORD_KEY)
	# make accounts  # prepare account directories
	# make recv      # call API and store as res.json
	# make data      # create data.jsonl from res.json
	# make db        # insert into ClickHouse
	# make run       # execute all above tasks

run:
	$(MAKE) accounts
	$(MAKE) recv
	$(MAKE) data
	$(MAKE) db
	@$(MAKE) done

recv: accounts
	for aid in `ls -1v accounts/ | grep -E '^[0-9]{1,}$$'`; do \
	  [ -f accounts/$$aid/res.json ] || $(MAKE) get/accounts/$$aid || exit 255; \
	done

get/accounts/%:
	@jq ".accountId = $*" req.json > "accounts/$*/req.json.err"
	@mv "accounts/$*/req.json.err" "accounts/$*/req.json"
	$(call api,get,accounts/$*/req.json,accounts/$*/res.json) || exit 255

each_jsonl: $(sort $(addsuffix data.jsonl,$(dir $(wildcard accounts/*/res.json))))

data: accounts
	make each_jsonl -j "$(NPROCS)"
	@rm -f "data.jsonl" "data.jsonl.tmp"
	@find accounts -type f -name 'data.jsonl' -exec cat {} + >> "data.jsonl.tmp"
	@mv "data.jsonl.tmp" "data.jsonl"
	@ls -lh "data.jsonl"

######################################################################
### accounts

accounts: $(ACCOUNTS_JSON)
	@rm -rf accounts
	@mkdir  accounts
	@jq -r '.rval.values[].account | select(.accountStatus == "SERVING") | .accountId' $(ACCOUNTS_JSON) | xargs -r -n1 -I@ mkdir "accounts/@"
	@echo "created: `find accounts -mindepth 1 -type d | wc -l` accounts"

accounts/%/data.jsonl : accounts/%/res.json
	@jq -f "$(MAP_JQ)" --arg RECORD_KEY "$(RECORD_KEY)" "$<" > "$@.err"
	@mv "$@.err" "$@"

accounts/%/num:
	@jq -c -r '.rval.totalNumEntries' "accounts/$*/res.json"

EACH_ACCOUNTS=ls -1v accounts/ | grep -E '^[0-9]{1,}$$' | sed -e 's|^|accounts/|'

map/%:
	@$(EACH_ACCOUNTS) | xargs -n1 -r -I@ sh -c 'printf "%s\t" "`basename @`"; make "@/$*"' || exit 2
