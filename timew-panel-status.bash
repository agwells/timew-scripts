#!/bin/bash

if $(timew >> /dev/null); then
    timew | head -n 1
else
    # Make it blink into ALL CAPS to try to remind
    # me to set a task.
    MSG=$(timew)
    if expr $(date +%s | tail -c 2) % 2 >> /dev/null; then
        echo $MSG
    else
        echo ${MSG^^}
    fi
fi