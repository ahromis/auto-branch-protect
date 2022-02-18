#!/bin/bash

REPO_URL=$1
DEFAULT_BRANCH=$2
GH_USER=$3
GH_PAT=${GH_TOKEN}
GH_PROTECTION_ENDPOINT=${REPO_URL}/branches/${DEFAULT_BRANCH}/protection
GH_ISSUE_ENDPOINT=${REPO_URL}/issues

# Ensure endpoint is ready
while [[ "$(curl -i -u ${GH_USER}:${GH_PAT} -s -o /dev/null -w ''%{http_code}'' ${REPO_URL})" != "200" ]];
    do sleep 1;
done

echo "Enabling branch protection on the repo."
curl -i -u ${GH_USER}:${GH_PAT} ${GH_PROTECTION_ENDPOINT} \
    -X PUT \
    -H "Accept: application/vnd.github.v3+json" \
    -d '{
	    "enforce_admins": null,
	    "required_pull_request_reviews": {
		"dismiss_stale_reviews": false,
		"dismissal_restrictions": {},
		"require_code_owner_reviews": true,
		"required_approving_review_count": 1
	    },
	    "required_status_checks": null,
	    "restrictions": null
	}'

echo "Creating issue mentioning new branch protection."
curl -i -u ${GH_USER}:${GH_PAT} ${GH_ISSUE_ENDPOINT} \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -d "{
	    \"title\": \"New Branch Protection Added\",
	    \"body\": \"@${GH_USER} A new branch protection was added to the ${DEFAULT_BRANCH} branch.\"
	}"
