#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(setup)"
{
  it "make clean in display/BudgetOrderService"
  (
    cd sandbox/display/BudgetOrderService
    make clean 2>/dev/null
  )

  it "replace display/AccountService data.jsonl with test fixture"
  {
    cp fixtures/display/AccountService/data.jsonl sandbox/display/AccountService/
  }
}

describe "display/BudgetOrderService"
(
  cd sandbox/display/BudgetOrderService
  EXPECTED="../../../fixtures/display/BudgetOrderService"

  it "make setup"
  {
    @run make setup
    @run diff -r base_accounts $EXPECTED/base_accounts
  }
)
