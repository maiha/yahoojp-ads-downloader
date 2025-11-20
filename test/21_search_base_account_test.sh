#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(setup)"
{
  it "make clean in search/BaseAccountService"
  (
    cd sandbox/search/BaseAccountService
    make clean 2>/dev/null
  )

  it "place res.json fixture in search/BaseAccountService"
  {
    cp fixtures/search/BaseAccountService/res.json sandbox/search/BaseAccountService/
  }
}

describe "search/BaseAccountService"
(
  cd sandbox/search/BaseAccountService
  EXPECTED="../../../fixtures/search/BaseAccountService"

  it "make data"
  {
    @run make data
    @run diff data.jsonl $EXPECTED/data.jsonl
  }
)
