#!/usr/bin/env bash

# files=$(find . -not -empty -type f -exec egrep -l " +$" {} \;  | grep -v '\.terraform')
for FILE in $(
    git ls-tree --full-tree --name-only -r HEAD \
        | grep -v 'woff$' \
        | grep -v 'png$' \
        | grep -v '\.ico$' \
        | grep -v '\.terraform' \
        | grep -v '^api/spec/combined_spec'
); do
    (sed -i 's/[[:space:]]*$//' "$FILE" >/dev/null 2>&1 || sed -i '' -E 's/[[:space:]]*$//' "$FILE")
done
