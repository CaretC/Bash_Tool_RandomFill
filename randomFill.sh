#! /bin/bash

# <<Description>>

# Variables
# =========
DIRECTORY=$(pwd)
LENGTH=255
SAFE="TRUE"
DATA="numeric"
EXTENSION=".txt"
VERBOSE="FALSE"
VERBOSE_SETUP_MSGS=()

# Terminal Colors
# ===============
RED="\033[0;31m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
DEFAULT="\033[0;37m"
CYAN="\033[0;36m"

# Functions
# =========
verboseSetupMsg() {                                                                                                            
    VERBOSE_SETUP_MSGS+=("$1")                                                           
}

printVerboseSetupMsgs() {
    if [[ $VERBOSE == "TRUE" ]]; then
        for msg in "${VERBOSE_SETUP_MSGS[@]}"; do
            echo -e $msg
        done
    fi
}

verboseMsg() {
    if [[ $VERBOSE == "TRUE" ]]; then
       echo -e "$1"
    fi
}

setDir() {
    # Check if the directory exists
    if [ -d $1 ]; then
        verboseSetupMsg "DIRECTORY set to ${BLUE}$1${DEFAULT}"

        DIRECTORY=$1
    else
        echo -e "${RED}Directory supplied $1 does not exists.${DEFAULT}"
        exit
    fi
}

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
    echo -e "\t --unsafe-mode\t Overide the current file content with the new data <<TODO>>"
    echo -e "\t -v, --verbose\t Enable verbose mode"
    echo
    echo EXAMPLES:
    echo -e "\t TODO: <<Add Examples>>"
}

setLen() {
    if [[ $1 -gt 0 && $1 -lt 65536 ]]; then
        verboseSetupMsg "Data length set to ${CYAN}$1${DEFAULT}"
        LENGTH=$1
    else
        echo "Invalid data length input, data length should be between 1 -> 35535 characters."
        exit
    fi
}

setDataNum() {
    if [[ $DATA != "numeric" ]]; then
        verboseSetupMsg "Data type set to ${GREEN}numeric${DEFAULT} from ${CYAN}$DATA${DEFAULT}"       
        DATA="numeric"
    else
        verboseSetupMsg "Data type already set to ${GREEN}numeric${DEFAULT}"
    fi
}

setText() {
    verboseSetupMsg "Files with the extension ${CYAN}.txt${DEFAULT} will be populated with data."
    EXTENSION=".txt"
}

addFileData() {
    if [[ $DATA == "numeric" ]]; then
        fileData=""
        
        for ((i = 0 ; i < $LENGTH ; i++)); do
            fileData+="1";
        done

        echo $fileData >> $DIRECTORY/$1
    fi
}

# Main
# ====

# Draft Args
# --unsafe-mode

# Confirm that at least one argument has been suppllied
if [[ $# -le 0 ]]; then
    echo Invalid number of arguments supplied, the funcion requires at lest one argument.
    exit
fi

# Loop through the function arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d | --dir)
            setDir $2
            shift # Shift past arg
            shift # Shift past value
            ;;
        -h | --help)
            displayHelp
            shift # Shift past arg
            ;;
        -l | --length)
            setLen $2
            shift # Shift past arg
            shift # Shift past value
            ;;
        -n | --numeric)
            setDataNum
            shift # Shift past arg
            ;;
        -t | --text)
            setText
            shift # Shift past arg
            ;;
        --unsafe-mode)
            echo Unsafe mode
            shift # Shift past arg
            ;;
        -v | --verbose)
            VERBOSE="TRUE"
            shift # Shift past arg
            ;;
        *)
            echo Invalid argument supplied $1
            shift # shift past arg
            ;;
    esac
done

# Print any verbose setup messages
printVerboseSetupMsgs

# Process Files
# -------------
# Start processing
verboseMsg "Starting to process ${CYAN}$EXTENSION${DEFAULT} files in ${BLUE}$DIRECTORY${DEFAULT}..."

# Change to required Directory
startDir=$(pwd)
cd $DIRECTORY

# Search DIRECTORY for valid files with EXTENSION
validFiles=$(ls | grep $EXTENSION)

# Display search result
validFileNum=$(wc -w <<< $validFiles)
verboseMsg "${GREEN}$validFileNum${DEFAULT} ${CYAN}$EXTENSION${DEFAULT} files found in ${BLUE}$DIRECTORY${DEFAULT}"

# Loop through all these files and populate with DATA
for file in $validFiles; do
    verboseMsg "Adding data to ${BLUE}$DIRECTORY/$file${DEFAULT}..."
    addFileData $file
done

# Return to original directory
cd $startDir

# Done
verboseMsg "All ${GREEN}$validFileNum${DEFAULT}${CYAN}$EXTENSION${DEFAULT} files in ${BLUE}$DIRECTORY${DEFAULT} processed."
verboseMsg "Script complete"
