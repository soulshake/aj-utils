#!/usr/bin/env bash

for FILE in $(
    git ls-tree --full-tree --name-only -r HEAD \
        | grep -v 'woff$' \
        | grep -v 'png$' \
        | grep -v '\.ico$' \
        | grep -v '^api/spec/combined_spec'
); do
    (sed -i 's/[[:space:]]*$//' "$FILE" >/dev/null 2>&1 || sed -i '' -E 's/[[:space:]]*$//' "$FILE")
done
