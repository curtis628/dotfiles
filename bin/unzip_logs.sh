#!/bin/sh
logroot=~/Downloads/symlogs
rm -rf $logroot
mkdir $logroot
log_files=`ls ~/Downloads | grep symphony-`
for file in $log_files; do
    folder=${file%.tgz}
    mkdir $logroot/$folder
    cd $logroot/$folder
    tar xf ~/Downloads/$file
done

mvim -p `find $logroot -name "symphony*.log"`
