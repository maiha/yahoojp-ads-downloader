include ../const.env
include ../../credential.env
include ../../lib/service.mk

usage:
	# make setup     # create base_accounts directories
	# make recv      # call API and store as res.json
	# make data      # create data.jsonl from res.json
	# make db        # insert into ClickHouse
	# make run       # execute all above tasks

######################################################################
### Action

run:
	$(MAKE) setup
	$(MAKE) recv
	$(MAKE) data
	$(MAKE) db
	@$(MAKE) done

.PHONY: setup
setup: base_accounts
	@$(MAKE) setup-impl

setup-impl: $(addsuffix /req.json,$(wildcard base_accounts/*))

base_accounts: $(BASE_ACCOUNTS_JSONL)
	@rm -rf base_accounts base_accounts.tmp
	@jq -r '.accountId' $< > base_account_ids.txt
	@! grep -qvE '^[0-9]+$$' base_account_ids.txt
	@cat base_account_ids.txt | xargs -I{} mkdir -p base_accounts.tmp/{}
	@mv base_accounts.tmp base_accounts

recv: setup
	@$(MAKE) recv-impl

recv-impl: $(addsuffix /res.json,$(wildcard base_accounts/*))

base_accounts/%/req.json: req.json
	@cp req.json "$@"

base_accounts/%/res.json: base_accounts/%/req.json
	@echo "Processing base_account_id: $*"
	$(call api,get,base_accounts/$*/req.json,$@,$*)

$(BASE_ACCOUNTS_JSONL):
	@make -s -C ../BaseAccountService run

done:
	@clickhouse-client -d "$(DB)" -q "SELECT accountType, count(*) FROM Account GROUP BY accountType limit 3 FORMAT PrettyCompactNoEscapes"

######################################################################
### Low rules

data: recv
	@$(MAKE) data-impl

data-impl: data.jsonl

data.jsonl: $(addsuffix /data.jsonl,$(wildcard base_accounts/*))
	@rm -f "$@.tmp"
	@find base_accounts -type f -name 'data.jsonl' | sort | xargs cat > "$@.tmp"
	@mv "$@.tmp" "$@"

# Pattern rule: generate base_accounts/*/data.jsonl from res.json
base_accounts/%/data.jsonl: base_accounts/%/res.json
	@jq -c --argjson base_id "$*" '.rval.values[] | select(.operationSucceeded == true) | .account + {baseAccountId: $$base_id}' "$<" > "$@.err"
	@mv "$@.err" "$@"

# Create accounts directory from data.jsonl for other services to use
accounts: data.jsonl
	@rm -rf accounts accounts.tmp
	@jq -r 'select(.accountStatus == "SERVING") | [.accountId, .baseAccountId] | @csv' $< > accounts.csv
	@! grep -qvE '^[0-9]+,[0-9]+$$' accounts.csv
	@cut -d, -f1 accounts.csv | xargs -I{} mkdir -p accounts.tmp/{}
	@awk -F, '{print $$2 > "accounts.tmp/" $$1 "/base_account_id"}' accounts.csv
	@mv accounts.tmp accounts
