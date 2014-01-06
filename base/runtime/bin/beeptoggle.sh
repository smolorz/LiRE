#! /bin/sh
if [ "$1" = "off" ]; then
    echo -e "\33[11;0]"
    echo "Bell turned off."
fi

if [ "$1" = "on" ]; then
    echo -e "\33[10;750]\33[11;250]"
    echo "Bell turned on."
fi

if [ "$1" = "" ]; then
    echo "Usage: $0 <on|off>"
fi