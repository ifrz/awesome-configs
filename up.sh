#!/bin/bash

uptime | awk '{printf "%s\n", $3}' | tr ',' ' '
