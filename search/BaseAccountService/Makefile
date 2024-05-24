include ../const.env
include ../../credential.env
include ../../lib/service.mk

mkfile_path := $(abspath $(firstword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

SERVICE=$(current_dir)
OAUTH_DIR=../../oauth
TOKEN_JSON=$(OAUTH_DIR)/token.json
BASE_ACCOUNT_JSON=base_account_id.json

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
$(call check_defined, RETRY_COUNT)

usage:
	# make recv      # call API and store as res.json

######################################################################
### Action

run:
	$(MAKE) recv

recv: req.json
	@curl -sS -X POST "${ENDPOINT}/${SERVICE}/get" \
	  -H "Content-Type: application/json" \
          -H "Authorization: Bearer `jq -r .access_token $(TOKEN_JSON)`" \
	  -d "@req.json" > "$(BASE_ACCOUNT_JSON).tmp"
	@grep accountId "$(BASE_ACCOUNT_JSON).tmp" > /dev/null
	@mv "$(BASE_ACCOUNT_JSON).tmp" $(BASE_ACCOUNT_JSON)
