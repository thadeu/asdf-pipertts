#!/usr/bin/env bash

fail() {
  echo -e "\033[31m$1\033[0m" >&2
  exit 1
}
