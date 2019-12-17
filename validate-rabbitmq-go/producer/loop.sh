#!/bin/bash

for counter in $(seq 1 255); do go run send.go $counter ; done
