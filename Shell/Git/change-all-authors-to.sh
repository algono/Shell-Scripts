#!/bin/bash

if [ "$#" != 2 ]
then
    echo "Usage: change-all-authors-to <name> <email>"
    exit 1
fi

read -r -d '' setVariables << EOF
CORRECT_NAME="$1"
CORRECT_EMAIL="$2"
EOF

checks='
export GIT_COMMITTER_NAME="$CORRECT_NAME"
export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"

export GIT_AUTHOR_NAME="$CORRECT_NAME"
export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
'

script="$setVariables$checks"

git filter-branch --env-filter "$script" --tag-name-filter cat -- --branches --tags
