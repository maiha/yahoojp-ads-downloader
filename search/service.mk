SEARCH_ENDPOINT=https://ads-search.yahooapis.jp/api/v5
DISPLAY_ENDPOINT=https://ads-display.yahooapis.jp/api/v5
DB=yahoo_search
NPROCS ?= 4

mkfile_path := $(abspath $(firstword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

SERVICE=$(current_dir)
OAUTH_DIR=../../oauth
TOKEN_JSON=$(OAUTH_DIR)/token.json
ACCOUNTS_JSON=../AccountService/res.json
TABLE=$(subst Service,,$(SERVICE))

######################################################################
### check required variables
### https://stackoverflow.com/questions/10858261/how-to-abort-makefile-if-variable-not-set

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

$(call check_defined, CLIENT_ID)
$(call check_defined, CLIENT_SECRET)
$(call check_defined, REFRESH_TOKEN)

######################################################################
all: usage

clean:
	rm -rf accounts res.* *.jsonl *.tmp data.*

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
	curl -s -X POST "$(SEARCH_ENDPOINT)/$(SERVICE)/$1" \
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

replace-data: data.jsonl
	clickhouse-client -d "$(DB)" -q "DROP TABLE IF EXISTS tmp_$(TABLE)"
	clickhouse-client -d "$(DB)" -q "CREATE TABLE tmp_$(TABLE) AS $(TABLE)"
	clickhouse-client -d "$(DB)" -n -q "SET input_format_skip_unknown_fields=1; INSERT INTO tmp_$(TABLE) FORMAT JSONEachRow" < "$<"
	clickhouse-client -d "$(DB)" -q "RENAME TABLE $(TABLE) TO $(TABLE)_old, tmp_$(TABLE) TO $(TABLE)"
	clickhouse-client -d "$(DB)" -q "DROP TABLE $(TABLE)_old"
	@printf "updated: $(TABLE) => "
	@clickhouse-client -d "$(DB)" -q "SELECT COUNT(*) FROM $(TABLE)"

######################################################################
### [develop] generate table.sql automatically

data.keys: data.jsonl
	jq -s -r '[ .[] | keys ] | flatten | unique | .[]' < "$<" > "$@.err"
	@mv "$@.err" "$@"

data.samples/%:
	mkdir -p "$(dir $@)"
	jq ".$*" data.jsonl | cut -b1 | sort | uniq | tr -d '\n' > "$@.err"
	mv "$@.err" "$@"

.PHONY : data.types
data.types: data.keys
	@for x in `cat data.keys`; do \
	  make data.types/$$x; \
	done

data.types/%: data.samples/%
	@mkdir -p "$(dir $@)"
	@rm -f "$@"
	@grep -q -v -E '^["n]+$$'   "$<" || echo String > "$@"
	@grep -q -v -E '^[0-9n]+$$' "$<" || echo Int64  > "$@"
	@[ -f "$@" ]

gen/table.sql: data.types
	@rm -f "table.sql" "table.sql.tmp"
	@touch "table.sql.tmp"
	@printf "%s" "CREATE TABLE IF NOT EXISTS $(TABLE) (" >> "table.sql.tmp"
	@for x in `cat data.keys`; do \
	  printf "\n  %s  %s," "$$x" "`cat data.types/$$x`" >> "table.sql.tmp"; \
	done
	@sed -i -e '$$ s/,//' "table.sql.tmp"
	@echo "\n) Engine = Log" >> "table.sql.tmp"
	@mv "table.sql.tmp" "table.sql"
