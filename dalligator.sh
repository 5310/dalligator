#!/bin/bash
# ------------------------------------------------------------------------------
# dalligator - Delegate between a prioritized list of running programs by path.
#
# Usage: dalligator <delegated_program_path>... [with <delegated_argument>...]
#
# Copyright (c) 2015 Sayantan Chaudhuri <sayantan.chaudhuri@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



# This token is used to separate the delegated programs from the arguments.
SEPARATOR="with"
# A brief helpful message.
HELP="Usage: dalligator <delegated_program_path>... [with <delegated_argument>...]"



# Prints out a brief helpful message.
if [ "$1" == "help" ] || { [ "$1" == "-h" ] || [ "$1" == "--help" ]; } then
    echo $HELP
    exit 0
fi



# Convert the arguments list into an array.
input=("$@")

# Separate out the delegate programs from the arguments.
defaultDelegate=false
runningDelegate=false
delegates=0
switch=false
arguments=()
argumentsIndex=0
for i in "${input[@]}"; do
    if [ "$i" != "$SEPARATOR" ] ; then
        if [ "$switch" != true ]; then
            # Until the separator is encountered, count as delegates.
            delegates=$((delegates+1))
            # Store the first running one delegate.
            if [ "$runningDelegate" == false ]; then
                if pgrep -f "^$i" > /dev/null; then
                    runningDelegate="$i"
                fi
            fi
            # And set the very first delegate as default.
            if [ "$defaultDelegate" == false ]; then
                defaultDelegate="$i"
            fi
        else
            # Else accumulate arguments.
            arguments[$argumentsIndex]="$i"
            argumentsIndex=$((argumentsIndex+1))
        fi
    else
        # The separator switches accumulation modes only for the first ocurrence.
        if [ "$switch" != true ]; then
            switch=true
        fi
    fi
done



# Handle missing delegates.

if [ "$delegates" == 0 ]; then
    echo Please provide at least two programs to delegate.
    echo $HELP
    exit 1
fi



# Launch delegate.

if [ "$runningDelegate" != false ]; then
    echo "Running instance of '$runningDelegate' found. Launching..."
    nohup "$runningDelegate" ${arguments[*]} >&/dev/null &
else
    echo "No running instances found. Launching '$defaultDelegate'..."
    nohup "$defaultDelegate" ${arguments[*]} >&/dev/null &
fi
