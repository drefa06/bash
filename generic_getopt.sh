## @file generic_getopt.sh
## @brief Generic function to parse input option
##
## @details
## **This is a function, not a script that can be used as is** \
## This function will parse input options and return some variables created
## according to a specific input format.
##
## Be very carefull about using a specific prefix to avoid duplicated name of variable
##
## input:
##     1 = short option format as expected by getopt (e.g. "ho:l:")
##     2 = varname prefix to use for output
##         e.g. varname=foo, option -o bar => create variable foo_o=bar
##     3 to last = input remaining put in variable <getopt_varname>_remain
##
## output:
##     variable:
##         - One <getopt_varname>_<option> per option
##         - <getopt_varname>_remain for remaining input
##     return:
##         0 (default)
##     exit:
##         None
##
## @param $1 option_format (type: ) options need for parsing (e.g. "ho:l:")
## @param $2 varname_prefix (type: ) prefix given to output variable
## @param $3 input_args (type: ) the arguments line to parse
##
## @usage
## @code
##     generic_getopt "<option_format>" <varname_prefix> <input_args>
## @endcode
##
## @example
## @code
##     generic_getopt "h" foo "-h bar baz"
## @endcode
## Will set a variable foo_h=1 and remain variable foo_remain="bar baz"
##

##############################################################################
# @function getopt_usage
# @brief usage of generic_getopt
#
# @details
# Because this script is sourced, we MUST use a specific name.
#
function getopt_usage() {
    cat << EOM
/!\ This is a function, not a script. It must be used from another function or script /!\ \


usage: generic_getopt <option_format> <varname_prefix> <input_args>

    $1 {option_format}   Option to be analyzed. eg "ho:l"
    $2 {varname_prefix}  Prefix of variable created. eg foo => for option o, create var foo_o
    $3 {input_args}      Input arguments to be parsed

EOM
}

##############################################################################
## @function getopt_get_array_index
## @brief Get array getopt_opts_array index of value
##
## @details
## print out the index of value found in array getopt_opts_array
##
## @param $1 value (type: ) value to look for in array
##
## @stdout index Index of value found in array (default: 0)
##
function getopt_get_array_index() {
    value=$1
    found=0
    for i in "${!getopt_opts_array[@]}"; do
        if [ "${getopt_opts_array[$i]}" == "${value}" ]; then
            echo "${i}";
            found=1
            break
        fi
    done
    if [ $found == 0 ]; then echo ""; fi
}

##############################################################################
## @function getopt_init_variable
## @brief Initialise variables to default
##
## @details
## parameter 1 of generic_getopt.sh if option list. This list give the suffix used to
## create variable. It is combined with parameter 2 of generic_getopt.sh \
##     option list = "ho:l" => 2 flags (h and l), 1 option with value (o)
##     prefix = foo
##     will create and init:
##         foo_h=0
##         foo_l=0
##         foo_o=""
##
function getopt_init_variable() {
    i=0
    while [ $i -lt ${#getopt_opts_array[@]} ]; do
        var_name=${getopt_varname}_${getopt_opts_array[$i]}
        # There is only one possible option and it is a flag
        if [ ${#getopt_opts_array[@]} == 1 ]; then
            eval $var_name=false
            break
        fi
        # The last element is a flag
        if [ $i == $((${#getopt_opts_array[@]} - 1)) ]; then
            eval $var_name=false
            break
        fi
        # if following option char is a ':', we should wait for a value
        if [ "${getopt_opts_array[$((i + 1))]}" == ":" ]; then
            eval $var_name=""
            i=$((i + 1))
        else
            eval $var_name=false
        fi

        i=$((i + 1))
    done
}

##############################################################################
# MAIN
##############################################################################

# test to check whether function is called directly or not
local test="" 2> /dev/null
if [ $? == 1 ]; then
    getopt_usage
    exit 1
fi

# init input parameters
local getopt_opts="$1"
local getopt_varname="$2"
local getopt_input="${*:3}"

# create an array of possible option
local getopt_opts_array=($(echo "$getopt_opts" | grep -o .))
getopt_init_variable

# Parse options according to format
local options=$(getopt -o "$getopt_opts" -- $getopt_input 2>/dev/null)
eval set -- "$options"

# Create dynamic variable for each options found
# Create a remaining variable for remaining input cmd
while true; do
    case $1 in
        --)
            # We finish the analyse of options
            # Set remain
            var_name=`echo "$getopt_varname"_remain`
            shift
            IFS= read -r -d '' "$var_name" <<< "$@"
            break;;
        *)
            # Analyse option

            # define variable name
            var_name=`echo "$getopt_varname"_"${1:1}"`
            # get index of current option in array of option
            getopt_opts_array_idx=$(getopt_get_array_index "${1:1}")
            # if next element in arry of option is ':' => we expect a following element
            # else it's a flag
            if [ "${getopt_opts_array[$(($getopt_opts_array_idx + 1))]}" == ":" ]; then
                # if following element is not '--', set var name with val,
                # else it means we forgot the following elem
                if [ "$2" != "--" ]; then
                    shift
                    if [ -z "${!var_name}" ]; then
                        eval $var_name=$1
                    else
                        local tmp="${!var_name} $1"
                        eval $var_name="$(echo $tmp | xargs | sed 's: :\\ :g')"
                    fi
                fi
            else
                eval $var_name=true
            fi
            ;;
    esac
    shift
done

return 0
