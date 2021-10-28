#!/usr/bin/env bash

#!/bin/bash
show_help() {
  cat <<HELPMSG
${APPNAME} ${VERSION} - Various checks to ensure the processing step was successful in all sessions

usage $0 [OPTION]... [ARGUMENT]...
  --version, -v         Prints the version and exits.
  --help, -h            Print this help message.

HELPMSG
}

APPNAME="ProcessStepChecks"
VERSION="0.1.0"

stdout_files_have_no_errors() {
  echo "================================================================================"
  echo "===  Checking the *.stdout files for errors ...                              ==="
  echo "================================================================================"
  files_exclude_pattern '*CHECK*/*.stdout' 'ERROR'
  return $?
}

source "$(dirname "$0")/../../common.sh" $@
source "$(dirname "$0")/../file_checks.sh"
stdout_files_have_no_errors
