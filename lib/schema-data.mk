# data.mk
#   generates `table.sql` from `data.jsonl`.

data.keys: data.jsonl
	jq -s -r '[ .[] | keys ] | flatten | unique | .[]' < "$<" > "$@.err"
	@mv "$@.err" "$@"

.PHONY : data.types
data.types: data.keys
	@for x in `cat data.keys`; do \
	  make data.types/$$x; \
	done

.PHONY : data.samples
data.samples: data.keys
	@for x in `cat data.keys`; do \
	  make data.samples/$$x; \
	done

data.samples/%:
	mkdir -p "$(dir $@)"
	jq ".$*" data.jsonl > "$@.err"
	mv "$@.err" "$@"

data.first/%: data.samples/%
	mkdir -p "$(dir $@)"
	cat "$<" | cut -b1 | sort | uniq | tr -d '\n' > "$@.err"
	mv "$@.err" "$@"

data.types/%: data.first/%
	@mkdir -p "$(dir $@)"
	@rm -f "$@"
	@grep -q -v -E '^["n]+$$'   "$<" || echo String > "$@"
	@grep -q -v -E '^[0-9n]+$$' "$<" || echo Int64  > "$@"
	@[ -f "$@" ]

gen/table.sql: data.samples data.types
	@rm -f "table.sql" "table.sql.tmp"
	@touch "table.sql.tmp"
	@printf "%s" "CREATE TABLE IF NOT EXISTS $(TABLE) (" >> "table.sql.tmp"
	@for x in `cat data.keys`; do \
	  printf "\n  %s %s," "$$x" "`cat data.types/$$x`" >> "table.sql.tmp"; \
	done
	@sed -i -e '$$ s/,//' "table.sql.tmp"
	@echo "\n) Engine = Log" >> "table.sql.tmp"
	@mv "table.sql.tmp" "table.sql"

