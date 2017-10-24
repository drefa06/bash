#!/bin/bash

###################################################################################
test_1()
{
    echo "#########################################################################"
    echo "### TEST 1: One choice allowed"

    echo "Do you agree? "
    expect -c "
        spawn ${TST_PRG}/q_and_a.sh --test \"yes sure,no I do not\"
        expect {
            \"Please, enter your choice\" { send \"5\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }
         
        expect {
            \"invalid choice: 5\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"1 2\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"1 choice allowed\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"1\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"yes sure\" { }
            timeout { exit 1 }
            failed { exit 2 }
            }
    "

    [ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"
}

###################################################################################
test_2()
{
    echo "#########################################################################"
    echo "### TEST 2: No choice allowed"
    echo "Do you agree? "
    expect -c "
        spawn ${TST_PRG}/q_and_a.sh --test -n \"yes sure,no I do not\"
        expect {
            \"Please, enter your choice\" { send \"5\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }
         
        expect {
            \"invalid choice: 5\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"1 3\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"choice cannot be 'none' and something else at same time\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"1\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"yes sure\" { }
            timeout { exit 1 }
            failed { exit 2 }
            }
    "

    [ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"
}

###################################################################################
test_3()
{
    echo "#########################################################################"
    echo "### TEST 3: No choice allowed"
    echo "Do you agree? "
    expect -c "
        spawn ${TST_PRG}/q_and_a.sh --test -n \"yes sure,no I do not\"
        expect {
            \"Please, enter your choice\" { send \"3 5\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"choice cannot be 'none' and something else at same time\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"3\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"NONE\" { }
            timeout { exit 1 }
            failed { exit 2 }
            }
    "

    [ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"
}

###################################################################################
test_4()
{
    echo "#########################################################################"
    echo "### TEST 4: Multiple choice allowed"
    echo "Do you agree? "
    expect -c "
        spawn ${TST_PRG}/q_and_a.sh --test -m \"yes sure,no I do not\"
        expect {
            \"Please, enter your choice\" { send \"5\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }
         
        expect {
            \"invalid choice: 5\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"1 2\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"yes sure,no I do not\" { }
            timeout { exit 1 }
            failed { exit 2 }
            }
    "

    [ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"
}

###################################################################################
test_5()
{
    echo "#########################################################################"
    echo "### TEST 5: Multiple choice allowed"
    echo "Do you agree? "
    expect -c "
        spawn ${TST_PRG}/q_and_a.sh --test -m \"yes sure,no I do not\"
        expect {
            \"Please, enter your choice\" { send \"3 1\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"yes sure,no I do not\" { }
            timeout { exit 1 }
            failed { exit 2 }
            }
    "

    [ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"
}

###################################################################################
test_6()
{
    echo "#########################################################################"
    echo "### TEST 6: None or Multiple choice allowed"
    echo "Do you agree? "
    expect -c "
        spawn ${TST_PRG}/q_and_a.sh --test -mn \"yes sure,no I do not\"
        expect {
            \"Please, enter your choice\" { send \"5\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }
         
        expect {
            \"invalid choice: 5\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"3 4\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"choice cannot be 'none' and something else at same time\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"2 4\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"choice cannot be 'none' and something else at same time\" {}
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"Please, enter your choice\" { send \"4\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"NONE\" { }
            timeout { exit 1 }
            failed { exit 2 }
            }
    "

    [ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"
}

###################################################################################
test_7()
{
    echo "#########################################################################"
    echo "### TEST 7: None or Multiple choice allowed"
    echo "Do you agree? "
    expect -c "
        spawn ${TST_PRG}/q_and_a.sh --test -mn \"yes sure,no I do not\"
        expect {
            \"Please, enter your choice\" { send \"3 1\r\" }
            timeout { exit 1 }
            failed { exit 2 }
            }

        expect {
            \"yes sure,no I do not\" { }
            timeout { exit 1 }
            failed { exit 2 }
            }
    "

    [ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"
}

###################################################################################
TST_call()
{
    func_name=$1
    shift
    func_args="$@"
    eval ${func_name} "${func_args}" 2> ${func_name}.err
    rc=$?
    if [ -f ${func_name}.err -a "`cat ${func_name}.err`" != "" ]; then
        echo "### ERROR ### in function ${func_name}"
        echo "### ERROR ### `cat ${func_name}.err`"
        rm -f ${func_name}.err
        return 1
    fi
    
    return $rc
}

###################################################################################
function TST_AbortProcess()
{
    echo "### ABORT ### Process aborted"
    echo "### ABORT ### During: $2 $3"
    echo "### ABORT ### exit 3"
    exit 3
}

###################################################################################
function TST_PostProcess()
{
    if [ -f $2.err ] && [ "`cat $2.err`" != "" ]; then
        echo "### ERROR ### in function $2"
        echo "### ERROR ### `cat $2.err`"
        rm -f $2.err
    fi 

    echo "### EXIT ### Cleaning Process before exit"
}

###################################################################################
###################################################################################
### 
###                                 MAIN
### 
###################################################################################
#source lib/utils.sh    #include utils tools

trap 'TST_PostProcess $? ${FUNCNAME[0]:+${FUNCNAME[0]}}' EXIT #trap exit
trap 'TST_AbortProcess $? ${BASH_SOURCE}:${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' SIGINT SIGTERM SIGKILL

TST_ME=$(basename -- "$0")
TST_PATH=$(dirname $(readlink -e -- "$0"))
TST_PRG=$(readlink -e -- "$TST_PATH/..")


LOGFILE="${ME%.*}.log"  #default logfile name   => modified by -l|--log <log_file>
if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi
TST_ERRFILE="${TST_ME%.*}.err"
if [ -f ${TST_ERRFILE} ]; then rm -f ${TST_ERRFILE}; fi

TST_LIST=`cat $TST_ME | grep '^test_[0-9]*()' | cut -d\( -f1`
declare -a TST_ARGS=( "" )



if [ ${#@} -lt 1 ]; then
    TST_ARGS=( "${TST_LIST[@]}" )
else
    TST_ARGS=( "$@" )
fi

for tst_name in ${TST_ARGS[@]}; do
    eval $tst_name
done




