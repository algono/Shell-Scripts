#!/bin/sh

if [ "$#" != 1 ]
then
    echo "Usage: delete-commits-from-author <old-email>"
    exit 1
fi

setVariables="OLD_EMAIL=\"$1\""

# Disabled linter error because we actually want the variables to not expand (aka be replaced with their values)
# (we want the "$VAR" to be literal, not changed to the value of the VAR variable)
# shellcheck disable=SC2016
checks='
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    skip_commit "$@";
else
    git commit-tree "$@";
fi
'
script="$setVariables$checks"

git filter-branch --commit-filter "$script" HEAD
