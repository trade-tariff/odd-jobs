#! /usr/bin/env bash

log_for () {
  local url=$1
  local repo=$2
  local sha1=$(curl --silent $url | jq '.git_sha1' | tr -d '"') 

  pushd "$repo"
  echo "$repo"
  echo
  echo "$sha1"
  echo
  git log --merges HEAD...$sha1 | grep -A 2 'Merge ' | grep -v '\-\-' | grep -v 'Merge' | awk '{$1=$1};1' | awk '!/^$/' | awk '{print "- "$0}'
  echo
  popd
}

frontend_log () {
  log_for "https://www.trade-tariff.service.gov.uk/healthcheck" "trade-tariff-frontend"
}

backend_log () {
  log_for "https://www.trade-tariff.service.gov.uk/api/v2/healthcheck" "trade-tariff-backend"
}

duty_log () {
  log_for "https://www.trade-tariff.service.gov.uk/duty-calculator/healthcheck" "trade-tariff-duty-calculator"
}

admin_log () {
  log_for "https://tariff-admin-production.london.cloudapps.digital/healthcheck" "trade-tariff-admin"
}

search_query_log () {
  log_for "https://www.trade-tariff.service.gov.uk/api/search/healthcheck" "trade-tariff-search-query-parser"
}

all_logs () {
 frontend_log  
 backend_log
 duty_log
 admin_log
 search_query_log
}

all_logs
