#!/bin/bash

# clean README.md
echo "" > README.md

dirs=('.')
subDirs=()
while [[ ${#dirs[@]} > 0 ]]; do
    curDir=${dirs[0]}
    dirs=(${dirs[@]:1:${#dirs[@]}})  # pop
    if [[ ${curDir} != "." ]]; then
        echo "" >>  README.md
        echo "# ${curDir:2}" >> README.md
        echo "" >>  README.md
    fi
    for file in ${curDir}/*
    do
        if [[ ! -e ${file} ]]; then
            continue
        fi
        if [[ -d ${file} ]]; then
            subDirs=(${subDirs[@]} ${file})  # push
        else
            echo "- [${file##*/}](${file// /%20})" >> README.md
        fi
    done
    dirs=(${subDirs[@]} ${dirs[@]})  # push
    subDirs=()
done
