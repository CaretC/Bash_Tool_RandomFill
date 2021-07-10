#! /bin/bash

# <<Description>>

# Variables
# =========
DIRECTORY=$(pwd)/test
LENGTH=255
SAFE="TRUE"
DATA="numeric"
EXTENSION=".txt"

# Terminal Colors
# ===============
RED="\033[0;31m"
BLUE="\033[0:34m"
DEFAULT="\033[0;37m"
CYAN="\033[0;36m"

# Functions
# =========
displayHelp() {
    echo Usage: randomFill [OPTION]..
    echo Populate a set of files with a specific file extension with random data to assist in testing.
    echo
    echo With no DIRECTORY specified the script will search the current directory.
    echo
    echo OPTIONS:
    echo -e "\t -d, --dir\t Set the DIRECTORY to search"
    echo -e "\t -h, --help\t Display help information"
    echo -e "\t -l, --length\t Specify the number of characters for data (255 characters default)"
    echo -e "\t -n, --numeric\t Populate the file with numeric data (default)"
    echo -e "\t -t, --text\t Populate all text (*.txt) files with data in DIRECTORY (default)"
    echo -e "\t --unsafe-mode\t Overide the current file content with the new data"
    echo
    echo EXAMPLES:
    echo -e "\t TODO: <<Add Examples>>"
}

# Main
# ====

# Draft Args
# -d | --dir
# -h | --help
# -l | --len
# -t | --text
# --unsafe-mode
# -n | --numeric

# Confirm that at least one argument has been suppllied
if [[ $# -le 0 ]]; then
    echo Invalid number of arguments supplied, the funcion requires at lest one argument.
fi

# Loop through the function arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d | --dir)
            echo Directory $2
            shift # Shift past arg
            shift # Shift past value
            ;;
        -h | --help)
            displayHelp
            shift # Shift past arg
            ;;
        -l | --length)
            echo Len $2
            shift # Shift past arg
            shift # Shift past value
            ;;
        -n | --numeric)
            echo Numeric
            shift # Shift past arg
            shift # Shift past value
            ;;
        -t | --text)
            echo Text
            shift # Shift past arg
            ;;
        --unsafe-mode)
            echo Unsafe mode
            shift # Shift past arg
            ;;
        *)
            echo Invalid argument supplied $1
            shift # shift past arg
            ;;
    esac
done
