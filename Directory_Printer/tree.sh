#!/bin/bash

if [ "$1" != "" ]
then
  cd "$1"
fi

pwd

if [ `ls -F -1 | grep "/" | wc -l` = 0 ]
then
  echo " -> no sub-directories"
fi

# Print directories recursively
ls -R
