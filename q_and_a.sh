#!/bin/bash


##############################################################
### get_answer [OPTION] "<answer1>,<answer2>,...,<answerN>"
##  echo a list of possible answers, like:
##  1. answer1 (can contains spaces, -, _, ...)
##  2. answer2
##  ...
##  N.  answerN
##  N+1. all (if option -m|--multi)
##  N+2. none (if option -n|--none)
##
##  get and return the result list under global GET_ANSWER_RESULT
##  if option multi is set, it can be a single,partial or complete list
##  unless only a single element is accepted
##  choice can be done by number (multi is space separated choice) or value
##############################################################
get_answer()
{
    #Need to have IFS=\n for good execution
    local before_IFS=$IFS
    IFS=$'\n'

    get_answer_usage="""usage: get_answer [OPTION] <answer1>,<answer2>,...,<answerN>
[OPTION]
  -m: multi choice available
  -n: none of the answer accepted
"""

    local multi="no"
    local none="no"

    ## Analyse input parameter
    local OPTIND o m n
    while getopts ":mn" o; do
        case "${o}" in
            m) 
                multi="yes";;
            n) 
                none="yes";;
            *) echo ${get_answer_usage}; exit 1 ;;
        esac
    done
    shift $((OPTIND-1))

    declare -a answers
    local save_IFS=$IFS
    IFS=","
    for e in $*; do
        answers=("${answers[@]}" "$e")
    done
    IFS=$save_IFS
    local nb_answers=${#answers[@]}
  
    if [ "$multi" == "yes" ]; then nb_answers=$((nb_answers+1)); fi
    if [ "$none" == "yes" ];  then nb_answers=$((nb_answers+1));fi

    local wrong_choice="yes"
    while [ "$wrong_choice" == "yes" ]; do
        i=0
        for answer in ${answers[@]}; do
            i=$((i+1))
            echo "$i. $answer"
        done
        if [ "${multi}" == "yes" ]; then 
            i=$((i+1))
            echo "$i. all"
            answer_all=$i
        fi
        if [ "${none}" == "yes" ]; then 
            i=$((i+1))
            echo "$i. none"
            answer_none=$i
        fi

        local save_IFS=$IFS
        IFS=" "
        if [ "${multi}" == "yes" ]; then echo -n "Please, enter your choice [1-$i] (space separated if multi): "  
        else                             echo -n "Please, enter your choice [1-$i] : "
        fi
        read mychoice
        declare -a choices=($mychoice)
        IFS=$save_IFS

        if [ "${multi}" == "no" -a "${none}" == "no" ]; then
            if [ ${#choices[@]} -gt 1 ]; then echo "1 choice allowed"
            elif [ $mychoice -gt $nb_answers ]; then echo "invalid choice: ${mychoice/ /}"
            else valid_choices=$mychoice; wrong_choice="no"
            fi

        elif [ "${none}" == "yes" ] && [ ${#choices[@]} -gt 1 ] && [ ! -z "`echo $mychoice | grep $answer_none`" ]; then
            echo "choice cannot be 'none' and something else at same time"

        #elif [ "${multi}" == "yes" -a "${none}" == "yes" ] && [ ! -z "`echo $mychoice | grep $answer_all | grep $answer_none`" ]; then
        #    echo "choice cannot be 'all' and 'none' at same time"

        elif [ "${multi}" == "yes" ]; then
            invalid_choices=""
            valid_choices=""
            for choice in ${choices[@]}; do
                if [ $choice -gt $nb_answers ]; then invalid_choices="$invalid_choices $choice"
                elif [ $choice -lt 1 ]; then         invalid_choices="$invalid_choices $choice"
                else                                 valid_choices="$valid_choices $choice"
                fi
            done
            if [ "$invalid_choices" != "" ]; then echo "invalid choice: ${invalid_choices/ /}"
            elif [ ! -z "`echo $mychoice | grep $answer_all`" ]; then
                valid_choices=""
                for((j=1;j<$answer_all;j++)); do
                    valid_choices="$valid_choices $j"
                done
                wrong_choice="no"
            else wrong_choice="no"
            fi

        elif [ "${none}" == "yes" ]; then
            if [ $mychoice -gt $nb_answers ]; then echo "invalid choice: ${mychoice/ /}"
            elif [ -z "`echo $mychoice | grep $answer_none`" ]; then
                valid_choices=$mychoice; wrong_choice="no"
            else valid_choices=""; wrong_choice="no"
            fi
            
        fi
        
    done

    local save_IFS=$IFS
    IFS=" "
    GET_ANSWER_RESULT=""
    for valid_choice in $valid_choices; do
        if [ "$GET_ANSWER_RESULT" == "" ]; then GET_ANSWER_RESULT="${answers[$((valid_choice-1))]}"
        else                                    GET_ANSWER_RESULT="$GET_ANSWER_RESULT,${answers[$((valid_choice-1))]}"
        fi
    done

    IFS=${before_IFS}
}


if [ ! -z "`echo $1 | grep '\-\-test'`" ]; then # For usual execution
    shift
    echo "get_answer \"$@\""
    get_answer "$@"

    echo "Your answer is:"
    [ -z "${GET_ANSWER_RESULT}" ] && echo "NONE" || echo ${GET_ANSWER_RESULT}
    read

fi



