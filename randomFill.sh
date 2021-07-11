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

errorMsg() {
    echo -e "${RED}$1${DEFAULT}"
    exit
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
    echo -e "\t --clear-data\t Clear all valid files of data to leave blank files"
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
        errorMsg "Invalid data length input, data length should be between 1 -> 35535 characters."        
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

setUnsafeMode() {
    echo -e "${RED}DANGER!${DEFAULT} Enabling unsafe-mode means that all the valid file content will be deleted and re-populated with random data!"
    echo "Please ensure you are sure that you want to use this option before you enable it as all changes are irriversable!"
    echo "Do you want to enable Unsafe-mode? [y/n]"

    validOption=0;

    while [[ $validOption != 1 ]]; do
        read input
        
        if [[ $input == "y" || $input == "Y" || $input == "yes" || $input == "Yes" ]]; then
            SAFE="FALSE"
            echo -e "Unsafe-mode enabled!"
            verboseSetupMsg "${RED}Unsafe-Mode Enabled! File content will be overwritten!${DEFAULT}"
            validOption=1
        elif [[ input == "n" || $input == "N" || $input == "n" || $input == "No" ]]; then
            SAFE="TRUE"
            echo "Unsafe-mode not enabled!"
            validOption=1
        else
            echo "Invalid option input please confirm with [y/n]"
        fi
    done
}

clearData() {
    echo -e "${RED}DANGER!${DEFAULT} Enabling this option means that all the valid file content will be deleted and files left empty!"
    echo "Please ensure you are sure that you want to use this option before you enable it as all changes are irriversable!"
    echo -e "Do you want to clear data in ${RED}ALL${DEFAULT} valid files? [y/n]" 
    validOption=0;                                                              
                                                                                 
    while [[ $validOption != 1 ]]; do                                           
        read input                                                              
                                                                                 
        if [[ $input == "y" || $input == "Y" || $input == "yes" || $input == "Yes" ]]; then
            SAFE="FALSE"                      
            DATA="clear"                                  
            echo -e "Data clear enabled!"                                      
            verboseSetupMsg "${RED}Data Clear Enabled! File content will be overwritten!${DEFAULT}"
            validOption=1                                                       
        elif [[ input == "n" || $input == "N" || $input == "n" || $input == "No" ]]; then
            SAFE="TRUE"                                                         
            echo "Data clear mode not enabled!"                                     
            validOption=1                                                       
        else                                                                    
            echo "Invalid option input please confirm with [y/n]"               
        fi                                                                      
    done  
}

addFileData() {
    if [[ $DATA == "numeric" ]]; then
        fileData=""
        
        for ((i = 0 ; i < $LENGTH ; i++)); do
            val=($RANDOM %10)
            fileData+="$val";
        done
        
        if [[ $SAFE == "TRUE" ]]; then
            echo $fileData >> $DIRECTORY/$1
        elif [[ $SAFE == "FALSE" ]]; then
            echo $fileData > $DIRECTORY/$1
        else
            errorMsg "Invalid saftey mode! Exiting script and leaving all files un-touched."
        fi        
    elif [[ $DATA == "clear" ]]; then
        > $DIRECTORY/$1
    else
        errorMsg "Invalid data mode! Exiting script and leaving all files un-touched."
    fi
}

# Main
# ====
# Confirm that at least one argument has been suplied
if [[ $# -le 0 ]]; then
    errorMsg Invalid number of arguments supplied, the funcion requires at lest one argument.
fi

# Loop through the function arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --clear-data)
            clearData
            shift # Shift past arg
            continue
            ;;
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
            setUnsafeMode
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
    if [[ $DATA != "clear" ]]; then
        verboseMsg "Adding data to ${BLUE}$DIRECTORY/$file${DEFAULT}..."
    else
        verboseMsg "Clearing data from ${BLUE}$DIRECTORY/$file${DEFAULT}..."
    fi

    addFileData $file
done

# Return to original directory
cd $startDir

# Done
verboseMsg "All ${GREEN}$validFileNum${DEFAULT} ${CYAN}$EXTENSION${DEFAULT} files in ${BLUE}$DIRECTORY${DEFAULT} processed."
verboseMsg "Script complete"
