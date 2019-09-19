#!/bin/sh

if [ "$#" != 1 ]
then
    echo "Usage: delete-commits-from-author <old-email>"
    exit 1
fi

setVariables="OLD_EMAIL=\"$1\""

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