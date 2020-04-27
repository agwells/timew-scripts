#!/bin/bash
IFS=$'\n'
#TAGS=( $(timew tags 3days | tail -n+4 | head -n-1 | grep -P '^.*[^\s](?=\s+-\s*)' -o | sort) )

#NEWTAG=$(zenity \
#    --height=500 \
#    --width=400 \
#    --list \
#    --editable \
#    --column="tag" \
#    --hide-header \
#    ${TAGS[@]})

NEWTAG=$(timew tags 3days | \
    tail -n+4 | \
    head -n-1 | \
    grep -P '^.*[^\s](?=\s+-\s*)' -o | \
    sort | \
    yad \
        --title="Start task" \
        --height=500 \
        --width=400 \
        --center \
        --list \
        --editable \
        --column="tag" \
        --no-headers \
        --separator=\
)

echo "Selected: \"${NEWTAG}\""

if [ "${NEWTAG}" ]; then
    timew start "${NEWTAG}" :adjust
else
    echo "Nothing selected; not updating timewarrior"
fi
