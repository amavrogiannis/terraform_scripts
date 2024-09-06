#!/bin/sh

use_me=1

if [ $use_me == 1 ]; then
    python test.py dev
elif [ $use_me == 2 ]; then
    python test.py staging
else
    echo "This branch has no supporting Task Definition target on ECS."
    exit 1
fi