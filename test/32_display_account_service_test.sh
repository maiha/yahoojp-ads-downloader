#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(setup)"
{
  it "make clean in display/AccountService"
  (
    cd sandbox/display/AccountService
    make clean 2>/dev/null
  )

  it "place BaseAccountService data.jsonl fixture"
  {
    cp fixtures/display/BaseAccountService/data.jsonl sandbox/display/BaseAccountService/
  }
}

describe "display/AccountService"
(
  cd sandbox/display/AccountService
  EXPECTED="../../../fixtures/display/AccountService"

  it "make setup"
  {
    @run make setup
    @run diff base_accounts/999999999/req.json $EXPECTED/base_accounts/999999999/req.json
    @run diff base_accounts/888888888/req.json $EXPECTED/base_accounts/888888888/req.json
  }

  it "place res.json files"
  {
    cp $EXPECTED/base_accounts/999999999/res.json base_accounts/999999999/
    cp $EXPECTED/base_accounts/888888888/res.json base_accounts/888888888/
  }

  it "make data"
  {
    @run make data
    @run diff data.jsonl $EXPECTED/data.jsonl
  }

  it "make accounts (SERVING filter)"
  {
    @run make accounts
    @run diff -r accounts $EXPECTED/accounts
  }
)
