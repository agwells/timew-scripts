#!/bin/bash

# to install:
# 1. sudo systemctl enable /home/aaronw/programs/timew-scripts/timew-sys.service
# 2. sudo systemctl daemon-reload
# may be able to test by doing "sudo pm-suspend" or "sudo systemctl suspend"
# or "sudo systemctl hibernate"
sudo -u aaronw /usr/local/bin/timew stop
