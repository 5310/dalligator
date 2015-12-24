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

delegates=()
delegatesIndex=0
switch=false
arguments=()
argumentsIndex=0
for i in "${input[@]}"; do
    if [ "$i" != "$SEPARATOR" ] ; then
        if [ "$switch" != true ]; then
            # Until the separator is encountered, accumulate programs.
            delegates[$delegatesIndex]="$i"
            delegatesIndex=$((delegatesIndex+1))
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

if [ "$delegatesIndex" == 0 ]; then
    echo Please provide at least two programs to delegate.
    echo $HELP
    exit 1
fi

# Launch the first available delegated program with the arguments.

found=false
for i in "${delegates[@]}"; do
    if pgrep -f "$i" > /dev/null; then
        # When a delegated program is already found to be running launch it!
        echo "Running instance of '$i' found. Launching..."
        nohup "$i" ${arguments[*]} >&/dev/null &
        found=true
        break
    fi
done
if [ "$found" = false ]; then
    # Else, launch the first program.
    echo "No running instances found. Launching '$i'..."
    nohup "${delegates[0]}" ${arguments[*]} >&/dev/null &
fi
