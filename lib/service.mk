-include local.env

SERVICE ?= $(notdir $(CURDIR))
TABLE ?= $(subst Service,,$(SERVICE))
TABLE_LC ?= $(shell echo "$(TABLE)" | tr A-Z a-z)
RECORD_KEY ?= $(TABLE_LC)Record

OAUTH_DIR=../../oauth
TOKEN_JSON=$(OAUTH_DIR)/token.json
ACCOUNTS_JSON=../AccountService/res.json

######################################################################
### check required variables
### https://stackoverflow.com/questions/10858261/how-to-abort-makefile-if-variable-not-set

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

# credential
$(call check_defined, CLIENT_ID)
$(call check_defined, CLIENT_SECRET)
$(call check_defined, REFRESH_TOKEN)

# const
$(call check_defined, ENDPOINT)
$(call check_defined, DB)
$(call check_defined, NPROCS)

######################################################################
all: usage

clean:
	rm -rf accounts res.* *.jsonl *.tmp data.* schema.*

clean.jsonl:
	find . -name '*.jsonl' | xargs -r rm

gc:
	@find . -name data.jsonl | xargs -r rm
	@find . -name res.json   | xargs -r -n1 "-P $(NPROCS)" gzip -f

######################################################################
### access token
token:
	@make -s -C $(OAUTH_DIR) token

######################################################################
### macro for API
### api <get> <req.json> <res.json>
define api
	@make -s -C $(OAUTH_DIR) token
	@rm -f "$3"
	curl -s -X POST "$(ENDPOINT)/$(SERVICE)/$1" \
	  -D "$3.header" \
	  -H "accept: application/json" \
	  -H "Authorization: Bearer `jq -r .access_token $(TOKEN_JSON)`" \
	  -H "Content-Type: application/json" \
	  -d "@$2" >  "$3.err"
	@grep -q '"errors":null' "$3.err" || jq .errors "$3.err"
	@mv "$3.err" "$3"
endef

######################################################################
### ClickHouse

db: create-database create-table replace-data

create-database:	
	clickhouse-client -q 'CREATE DATABASE IF NOT EXISTS $(DB)'

create-table: table.sql
	clickhouse-client -d "$(DB)" < "$<"

replace-data: data.jsonl table.sql
	clickhouse-client -d "$(DB)" -q "DROP TABLE IF EXISTS tmp_$(TABLE)"
	sed -e 's/^CREATE TABLE .*$$/CREATE TABLE tmp_$(TABLE) (/' table.sql | clickhouse-client -d "$(DB)"
	clickhouse-client -d "$(DB)" -n -q "SET input_format_skip_unknown_fields=1; INSERT INTO tmp_$(TABLE) FORMAT JSONEachRow" < "$<"
	clickhouse-client -d "$(DB)" -q "RENAME TABLE $(TABLE) TO $(TABLE)_old, tmp_$(TABLE) TO $(TABLE)"
	clickhouse-client -d "$(DB)" -q "DROP TABLE $(TABLE)_old"
	@printf "updated: $(TABLE) => "
	@clickhouse-client -d "$(DB)" -q "SELECT COUNT(*) FROM $(TABLE)"

######################################################################
### usage for schema
schema:
	@echo make -f ../../lib/schema.mk
