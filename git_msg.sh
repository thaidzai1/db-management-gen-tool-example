#!/bin/bash
msg=$(curl -H "PRIVATE-TOKEN: $API_TOKEN" "$CI_API_V4_URL/projects/$CI_PROJECT_ID/repository/commits/$CI_COMMIT_SHA" | jq '.message')
echo $msg | grep -o "[^\"]*"
