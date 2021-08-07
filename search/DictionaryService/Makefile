include ../../credential.env
include ../service.mk

TABLE=GeographicLocation

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

recv:
	$(call api,getGeographicLocation,req.json,res.json)

done:
	:

######################################################################
### Low rules

data: res.json
	jq -c '.rval.values[] | select(.operationSucceeded == true) | .geographicLocation.child[]' "$<" > "data.jsonl.err"
	mv "data.jsonl.err" "data.jsonl"
