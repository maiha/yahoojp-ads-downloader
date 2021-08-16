# schema.mk
#   generates `table.sql` from `schema.yaml`.

-include ../const.env
-include const.env

SERVICE ?= $(notdir $(CURDIR))
TABLE ?= $(subst Service,,$(SERVICE))
TABLE_LC ?= $(shell echo "$(TABLE)" | tr A-Z a-z)
SCHEMA_FILE ?= $(TABLE)
SCHEMA_KEY ?= $(SCHEMA_FILE)
SCHEMA_RB=../../lib/schema.rb

all: usage

usage:
	# SERVICE=$(SERVICE)
	# TABLE=$(TABLE)
	# TABLE_LC=$(TABLE_LC)
	# RECORD_KEY=$(RECORD_KEY)
	# SCHEMA_KEY=$(SCHEMA_KEY)
	@echo make -f ../../lib/schema.mk schema.yaml
	@echo make -f ../../lib/schema.mk table.sql

schema.yaml:
	@rm -f "$@.err"
	curl -f "https://raw.githubusercontent.com/yahoojp-marketing/ads-$(API)-api-documents/master/design/v$(V)/$(TABLE_LC)/$(SCHEMA_FILE).yaml" > "$@.err"
	@mv "$@.err" "$@"

schema.json: schema.yaml
	@yq -j e . "$<" | jq -c -r '.$(SCHEMA_KEY).properties | to_entries | .[] | {key: .key, type: .value.type, format: .value.format}' > "$@.err"
	@mv "$@.err" "$@"

table.sql: $(SCHEMA_RB) schema.json
	ruby "$<" > "$@.tmp"
	@mv "$@.tmp" "$@"
