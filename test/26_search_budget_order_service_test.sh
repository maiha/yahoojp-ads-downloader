#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(setup)"
{
  it "make clean in search/BudgetOrderService"
  (
    cd sandbox/search/BudgetOrderService
    make clean 2>/dev/null
  )

  it "replace search/AccountService data.jsonl with test fixture"
  {
    cp fixtures/search/AccountService/data.jsonl sandbox/search/AccountService/
  }
}

describe "search/BudgetOrderService"
(
  cd sandbox/search/BudgetOrderService
  EXPECTED="../../../fixtures/search/BudgetOrderService"

  it "make setup"
  {
    @run make setup
    @run diff -r base_accounts $EXPECTED/base_accounts
  }
)
