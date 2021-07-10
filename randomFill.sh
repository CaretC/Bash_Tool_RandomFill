#! /bin/bash

# <<Description>>

# Variables
# =========

# Terminal Colors
# ===============

# Functions
# =========

# Main
# ====

# Draft Args
# -d | --dir
# -h | --help
# -l | --len
# -t | --text
# --unsafe-mode
# -n | --numeric

# Loop through the function arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d | --dir)
            echo Directory $2
            shift # Shift past arg
            shift # Shift past value
            ;;
        -h | --help)
            echo Help
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
