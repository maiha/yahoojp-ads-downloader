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

ACCOUNT_DIR=../AccountService
ACCOUNTS_JSONL=$(ACCOUNT_DIR)/data.jsonl

base_accounts: $(ACCOUNTS_JSONL)
	@rm -rf base_accounts base_accounts.tmp
	@jq -r '.baseAccountId' $< | sort -u > base_account_ids.txt
	@! grep -qvE '^[0-9]+$$' base_account_ids.txt
	@cat base_account_ids.txt | xargs -I{} mkdir -p base_accounts.tmp/{}
	@mv base_accounts.tmp base_accounts

recv: setup
	@$(MAKE) recv-impl

recv-impl: $(addsuffix /res.json,$(wildcard base_accounts/*))

$(ACCOUNTS_JSONL):
	@make -s -C $(ACCOUNT_DIR) data

base_accounts/%/req.json: req.json $(ACCOUNTS_JSONL)
	@jq ".accountIds = $$(jq -s '[.[] | select(.baseAccountId == $*) | .accountId]' $(ACCOUNTS_JSONL))" req.json > "$@.tmp"
	@mv "$@.tmp" "$@"

base_accounts/%/res.json: base_accounts/%/req.json
	@echo "Processing base_account_id: $*"
	$(call api,get,base_accounts/$*/req.json,$@,$*)

done:
	@clickhouse-client -d "$(DB)" -q "SELECT accountType, limitChargeType, count(*) FROM $(TABLE) GROUP BY accountType, limitChargeType limit 3 FORMAT PrettyCompactNoEscapes"

######################################################################
### Low rules

data: recv
	@$(MAKE) data-impl

data-impl: data.jsonl

data.jsonl: $(addsuffix /data.jsonl,$(wildcard base_accounts/*))
	@rm -f "$@.tmp"
	@find base_accounts -type f -name 'data.jsonl' | sort | xargs cat > "$@.tmp"
	@mv "$@.tmp" "$@"

base_accounts/%/data.jsonl: base_accounts/%/res.json
	@jq -c '.rval.values[] | select(.operationSucceeded == true) | .budgetOrder' "$<" > "$@.err"
	@mv "$@.err" "$@"
