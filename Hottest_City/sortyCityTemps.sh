#!/bin/bash

cities=("Madrid" "Barcelona" "London")

for city in "${cities[@]}"
do
    sleep 1
    temperature=$(./weather.sh -s "$city" | sed -e 's/+//g' -e 's/°C//g')
    echo "$temperature" >> temperatures.txt
done

sort -k2 -r temperatures.txt > sorted_temperatures.txt

echo "SCRIPT FINISHED"