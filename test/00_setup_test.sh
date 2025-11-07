#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
source "$SCRIPT_DIR/test_helper.sh"

describe "(global setup)"
{
  it "prepare sandbox directory"
  {
    rm -rf sandbox
    mkdir -p sandbox
  }

  it "copy entire environment (lib, search, display)"
  {
    cp -r ../lib sandbox/
    cp -r ../search sandbox/
    cp -r ../display sandbox/
  }

  it "create stub credential.env"
  {
    touch sandbox/credential.env
  }
}

describe "global setup verification"
{
  it "lib copied correctly"
  {
    @run diff -r ../lib sandbox/lib
  }

  it "search copied correctly"
  {
    @run diff -r ../search sandbox/search
  }

  it "display copied correctly"
  {
    @run diff -r ../display sandbox/display
  }
}
