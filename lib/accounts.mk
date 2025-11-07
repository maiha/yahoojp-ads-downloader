ACCOUNT_DIR=../AccountService
ACCOUNTS_JSONL=$(ACCOUNT_DIR)/data.jsonl

usage:
	# make setup     # prepare account directories
	# make recv      # call API
	# make data      # create data.jsonl
	# make db        # insert into ClickHouse
	# make run       # execute all above tasks

run:
	$(MAKE) setup
	$(MAKE) recv
	$(MAKE) data
	$(MAKE) db
	@$(MAKE) done

.PHONY: setup
setup: accounts
	@$(MAKE) setup-impl

setup-impl: $(addsuffix /req.json,$(wildcard accounts/*))

recv: setup
	for aid in `ls -1v accounts/`; do \
	  [ -f accounts/$$aid/res.json ] || $(MAKE) get/accounts/$$aid || exit 255; \
	done

accounts/%/req.json: req.json accounts/%/base_account_id
	@jq ".accountId = $*" req.json > "$@.tmp"
	@mv "$@.tmp" "$@"

get/accounts/%:
	$(call api,get,accounts/$*/req.json,accounts/$*/res.json,`cat accounts/$*/base_account_id`) || exit 255

each_jsonl: $(sort $(addsuffix data.jsonl,$(dir $(wildcard accounts/*/res.json))))

data: accounts
	make each_jsonl -j "$(NPROCS)"
	@rm -f "data.jsonl" "data.jsonl.tmp"
	@find accounts -type f -name 'data.jsonl' -exec cat {} + >> "data.jsonl.tmp"
	@mv "data.jsonl.tmp" "data.jsonl"
	@ls -lh "data.jsonl"

######################################################################
### accounts

accounts: $(ACCOUNT_DIR)/accounts
	rm -rf accounts
	cp -pr "$<" .

$(ACCOUNT_DIR)/accounts:
	@make -s -C $(ACCOUNT_DIR) accounts

$(ACCOUNTS_JSONL):
	@make -s -C $(ACCOUNT_DIR) run

accounts/%/data.jsonl : accounts/%/res.json
	@jq -f map.jq "$<" > "$@.err"
	@mv "$@.err" "$@"
