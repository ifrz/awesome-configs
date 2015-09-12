#!/bin/bash

top  -b -n 1 -w 512  | awk '{printf "%5s  %4s    %4s   %4s   %s\n", $1, $2, $9, $10, $12}' | grep -A 5 PID
