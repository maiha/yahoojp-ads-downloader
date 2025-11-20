#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(setup)"
{
  it "make clean in display/CampaignService"
  (
    cd sandbox/display/CampaignService
    make clean 2>/dev/null
  )

  it "replace display/AccountService data.jsonl with test fixture"
  {
    cp fixtures/display/AccountService/data.jsonl sandbox/display/AccountService/
  }
}

describe "display/CampaignService"
(
  cd sandbox/display/CampaignService
  EXPECTED="../../../fixtures/display/CampaignService"

  it "make setup"
  {
    @run make setup
    @run diff -r accounts $EXPECTED/accounts
  }
)
