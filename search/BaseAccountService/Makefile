include ../const.env
include ../../credential.env
include ../../lib/service.mk

mkfile_path := $(abspath $(firstword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

SERVICE=$(current_dir)
OAUTH_DIR=../../oauth
TOKEN_JSON=$(OAUTH_DIR)/token.json

usage:
	# make setup     # NOP
	# make recv      # call API
	# make data      # create data.jsonl

######################################################################
### Action

run:
	$(MAKE) setup
	$(MAKE) recv
	$(MAKE) data

.PHONY: setup
setup:
	@:

$(TOKEN_JSON):
	@make -s -C $(OAUTH_DIR) token

.PHONY: recv
recv: req.json $(TOKEN_JSON)
	@curl -sS -X POST "${ENDPOINT}/${SERVICE}/get" \
	  -H "Content-Type: application/json" \
	  -H "Authorization: Bearer `jq -r .access_token $(TOKEN_JSON)`" \
	  -d "@req.json" > res.json

.PHONY: data
data:
	@jq --exit-status -c '.rval.values[].account' res.json > "data.jsonl.tmp"
	@mv "data.jsonl.tmp" "data.jsonl"
