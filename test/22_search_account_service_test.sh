#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(setup)"
{
  it "make clean in search/AccountService"
  (
    cd sandbox/search/AccountService
    make clean 2>/dev/null
  )

  it "place BaseAccountService data.jsonl fixture"
  {
    cp fixtures/search/BaseAccountService/data.jsonl sandbox/search/BaseAccountService/
  }
}

describe "search/AccountService"
(
  cd sandbox/search/AccountService
  EXPECTED="../../../fixtures/search/AccountService"

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
