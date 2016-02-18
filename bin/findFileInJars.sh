#! /bin/bash
find . | grep jar$ | while read fname; do jar tf $fname | grep $1 && echo $fname; done
