#!/bin/bash
directory=$1
[ "$(ls -A $directory)" ] && echo "normal" || echo "failure"
