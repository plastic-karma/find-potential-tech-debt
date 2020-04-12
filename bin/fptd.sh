#!/bin/bash

# Usage: Call fptd.sh in git repository root
# Output: comma separated values: filename,blanks,comments,code,commits,active_days

# Retrieves and parses 'git effort' output
function findEffort() {
    # find all files changed more than 5 times
    git effort --above 5 | \
    # remove duplicates
    sort | uniq | \
    # filter out uninteresting lines
    grep -v "active days" | \
    # filter out special characters that were used for coloring
    grep -v "[^[:print:]]" | \
    # filter out blank lines
    grep -v "^$" | \
    # sort by highest change rate             
    sort -k2 -r -n | \
    # remove '.....' in output          
    sed 's#\.\{2,\}#,#g' | \
    # remove leading whitespaces       
    sed 's/^ *//g' | \
    # adjust separator from long whitespace to comma             
    sed "s/ \{2,\}/,/g" | \
    # remove remaining whitespace        
    sed 's/ //g'                   
}

# Gets cloc information for a single file
function findCLOC() {
    # get cloc information
    cloc $1 --csv --quiet -by-file | \
    # ignore filename and language information 
    cut -d',' -f3- | \
    # only look at lines that contain cloc information (must start with digit)
    grep "^\d" | \
    # only use one line (to ignore summary line)
    head -n1
}

# extracts filename out of 'git effort' result
function getFileName() {
    echo $1 | cut -d',' -f1
}

# extracts commits and active days out of 'git effort' result
function getEffort() {
    echo $1 | cut -d"," -f2-
}

function main() {
    echo 'filename,blanks,comments,code,commits,active_days'
    for effortdata in `findEffort`
    do
        fileName=`getFileName $effortdata`

        # commits, active days
        effortForFile=`getEffort $effortdata`

        # blank,comment,code
        clocForFile=`findCLOC $fileName`
        if [ ! -z $fileName ] && [ ! -z $clocForFile ] && [ ! -z $effortForFile ]
        then
            echo "$fileName,$clocForFile,$effortForFile"
        fi
    done
}

main
