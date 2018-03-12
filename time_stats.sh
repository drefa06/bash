#!/bin/bash

if [ `echo "${BASH_VERSION}" | cut -d. -f1` -lt 4 ]; then
    echo "Need bash 4.x to work"
    declare -a TP_LIST=()

else
    declare -A TP_LIST=()
fi

tp_get_avail()
{
    if [ "${#TP_LIST[@]}" == "-" ]; then echo 0
    else
        found="no"
        for ((i=0;i<${#TP_LIST[@]};i++)); do
            if [ "${TP_LIST[$i]}" == "-" ]; then 
                echo $i
                found="yes"
                break
            fi 
        done
        if [ "$found" != "yes" ]; then
            echo ${#TP_LIST[@]}
        fi 
        
    fi
}
tp_reset()
{ 
    echo "time point reset: $1"
    TP_LIST[$1]="-"
}
tp_remove()
{ 
    echo "time point remove: $1"
    unset TP_LIST[$1]
}

tp_start()
{
    echo "time point start: $1"
    TP_LIST[$1]=`date +%s`
}

tp_duration()
{
    local tp_stop=`date +%s`
    echo $((tp_stop-${TP_LIST[$1]}))
}

tp_print()
{
    echo "TP_LIST:"
    for idx in ${!TP_LIST[@]}; do
        echo "    $idx: ${TP_LIST[$idx]}"
    done
}

echo "test time stats"

tp_start "global"
tp_1=`tp_get_avail`
tp_start ${tp_1}
echo "Do Something"
sleep 1
tp_2=`tp_get_avail`
tp_start ${tp_2}
echo "Duration_${tp_1}=`tp_duration ${tp_1}`"
tp_reset ${tp_1}
echo "Do Something"
sleep 2
tp_3=`tp_get_avail`
tp_start ${tp_3}
echo "Do Something"
sleep 3
echo "Duration_${tp_2}=`tp_duration ${tp_2}`"
echo "Do Something"
sleep 4
echo "Duration_${tp_3}=`tp_duration ${tp_3}`"
echo "Duration_${tp_2}=`tp_duration ${tp_2}`"
tp_reset ${tp_3}

echo "Duration_global=`tp_duration global`"

tp_print

tp_remove ${tp_1}
tp_remove global

tp_print



