#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(setup)"
{
  it "make clean in display/BaseAccountService"
  (
    cd sandbox/display/BaseAccountService
    make clean 2>/dev/null
  )

  it "place res.json fixture in display/BaseAccountService"
  {
    cp fixtures/display/BaseAccountService/res.json sandbox/display/BaseAccountService/
  }
}

describe "display/BaseAccountService"
(
  cd sandbox/display/BaseAccountService
  EXPECTED="../../../fixtures/display/BaseAccountService"

  it "make setup"
  {
    @run make setup
    @run diff -r base_accounts $EXPECTED/base_accounts
  }

  it "make data"
  {
    @run make data
    @run diff data.jsonl $EXPECTED/data.jsonl
  }
)
