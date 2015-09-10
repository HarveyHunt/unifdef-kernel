#!/bin/bash

set -e

unifdef -V >/dev/null 2>&1 || { echo "unifdef is required"; exit 1; }

if [ $# -eq 1 ]; then
    echo $(basename $0) "<Kconfig> [unifdef args]"
else 
    conf=$1
    shift
fi

while read setting
do
    if [[ $setting == *"is not set" ]]; then
        setting=$(echo $setting | cut -c 3-)
        args="$args -U${setting% is not set}"
    elif [[ $setting == *"=y" ]]; then
        args="$args -D${setting%=y}"
    fi
done < $conf

args="$args $@"

unifdef $args
