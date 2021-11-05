#!/usr/bin/env bash

get_variables_from_filepath() {
  # $1: filepath or current working directory
  ROOT_PATH="$(realpath ${1:-.})"
  local basedirectory=$(basename $ROOT_PATH)

  # Check the the directory is valid path
  if [[ $basedirectory =~ \..+_.+\..+\..+ ]]; then
    # split basedirectory into 4 parts, delimited by "."
    IFS='.' read -a parts <<<$basedirectory

    PIPELINE_NAME=${parts[0]}
    SESSION=${parts[1]}
    TIMESTAMP=${parts[2]}
    STEP=${parts[3]}
    SUBJECT="$(echo $SESSION | cut -d'_' -f1)"
    SCAN="$(echo $SESSION | cut -d'_' -f2-)"
  else
    echo "ERROR: $basedirectory is not a valid filepath"
    return 1
  fi

  PROJECT=$(basename $(dirname $ROOT_PATH))
  return 0
}

is_valid_check_dir(){
  ROOT_PATH="$(realpath ${1:-.})"
  get_variables_from_filepath $ROOT_PATH

  # if $STEP is "XNAT_CHECK_DATA" then return 0 else return 1
  if [ "$STEP" == "XNAT_CHECK_DATA" ]; then
    return 0
  else
    return 1
  fi
}