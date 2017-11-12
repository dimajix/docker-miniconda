#!/bin/bash

# Improved version of envsubst which keeps unknown variables
envsubst() {
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < $1 > $2
}

render_templates() {
    local SRC_DIR=$1
    local DST_DIR=$2

    mkdir -p $DST_DIR

    for f in $SRC_DIR/*
    do
        local src_name=$f
        local dst_name=$DST_DIR/$(basename $f)
        if [ -d $src_name ]; then
            mkdir -p $dst_name
            render_templates $src_name $dst_name
        else
            echo $src_name "=>" $dst_name
            # take action on each file. $f store current file name
            tp_render < $src_name > $dst_name
        fi
    done
}


check_dirs() {
    for d in $(echo $1 | tr "," "\n"); do
        if [ ! -d $d ]; then
            return 1
        fi
    done

    return 0
}

