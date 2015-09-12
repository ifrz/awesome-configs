#!/bin/bash

udisks --dump | grep -A 25 -B 1 Attribute | grep -B 22 -m 1 sda1 | head -20 -
