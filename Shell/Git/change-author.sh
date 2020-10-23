#!/bin/bash

if [ "$#" != 3 ]
then
    echo "Usage: change-author <old-email> <correct-name> <correct-email>"
    exit 1
fi

read -r -d '' setVariables << EOF
OLD_EMAIL="$1"
CORRECT_NAME="$2"
CORRECT_EMAIL="$3"
EOF

# Disabled linter error because we actually want the variables to not expand (aka be replaced with their values)
# (we want the "$VAR" to be literal, not changed to the value of the VAR variable)
# shellcheck disable=SC2016
checks='
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
'

script="$setVariables$checks"

git filter-branch --env-filter "$script" --tag-name-filter cat -- --branches --tags
