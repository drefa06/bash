#bash general scripts

## q_and_a.sh

when you need to have a question and answer function ready to use and it test script.

the function under q_and_a.sh is get_answer. copy it in your script or source this file. 

```bash
usage: get_answer [OPTION] <answer1>,<answer2>,...,<answerN>
[OPTION]
  -m: multi choice available
  -n: none of the answer accepted
```

with option -m, you are able to choose more than one answer.
with option -n, you can have a special choice to get any of the proposed solutions.

The choice(s) is(are) put under global variable GET_ANSWER_RESULT

### examples

#### example 1:
```bash
echo "What is your favorite color ? "
get_answer "blue,yellow,red"
echo -e "OK, you like color: \n\"${GET_ANSWER_RESULT}\"\n"
```
result 1:
```
What is your favorite color ? 
1. blue
2. yellow
3. red
Please, enter your choice [1-3] : 1 3     # without -n option, only 1 choice is possible
1 choice allowed
1. blue
2. yellow
3. red
Please, enter your choice [1-3] : 4       # possible answer is 1, 2 or 3... not 4
invalid choice: 4
1. blue
2. yellow
3. red
Please, enter your choice [1-3] : 1
OK, you like color: 
"blue"
```

#### example 2:
```bash
echo "What is your favorite color ? "
get_answer -n "blue,yellow,red"
echo -e "OK, you like color: \n\"${GET_ANSWER_RESULT}\"\n"
```
result 2:
```
What is your favorite color ? 
1. blue
2. yellow
3. red
4. none
Please, enter your choice [1-3] : 4
OK, you like color: 
""
```

#### example 3:
```bash
echo "What is your favorite color ? "
get_answer -nm "blue,yellow,red"
echo -e "OK, you like color: \n\"${GET_ANSWER_RESULT}\"\n"
```
result 3:
```
What is your favorite color ? 
1. blue
2. yellow
3. red
4. all
5. none
Please, enter your choice [1-3] : 1 5     # none or something else, invalid choice
choice cannot be 'none' and something else at same time
1. blue
2. yellow
3. red
4. all
5. none
Please, enter your choice [1-3] : 2 4     # possible choice, but choice 2 is include in choice 4
OK, you like color: 
"blue,yellow,red"
```

### test with q_and_a_test.sh

To simulate this interactiv case, I use expect tools.

It expect for an answer until timeout happen or fail, if answer happen, it send something.

I choose to include expect under bash script, but you can define an expect file that contains all possibles cases

spawn launch the shell script (with special option --test) and listen for expected sentences.
```spawn ./q_and_a.sh --test -n \"yes sure,no I do not\"```

then if expected sentence (e.g. "Please, enter your choice") happen, it send "3 5\r" to stdin
if timeout happen without expected command, it exit script with code 1
if a fail happen during execution, it exit script with code 2
```
expect {
    \"Please, enter your choice\" { send \"3 5\r\" }
    timeout { exit 1 }
    failed { exit 2 }
    }
```

At the end I test the return code to define if test succeed or not.
Here an inline if statement.
```[ $? -eq 0 ] && echo "TEST => [OK]" || echo "TEST => [NOK]"```

The full test:
```bash
test_3()
{
    echo "#########################################################################"
    echo "### TEST 3: No choice allowed"
    echo "Do you agree? "
    expect -c "
        spawn ./q_and_a.sh --test -n \"yes sure,no I do not\"
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
```





