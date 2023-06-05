#!/usr/bin/bash
ip link set "$1" master pnet0
ip link set "$1" up
