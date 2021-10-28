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
  files_exclude_pattern '*CHECK*/*.stdout' 'ERROR' >/dev/null
  if [ $? -ne 0 ]; then
    echo "ERROR: stdout files have errors"
    echo "$fail"
    return 1
  fi
  return 0
}

source "$(dirname "$0")/../../common.sh" $@
source "$(dirname "$0")/../file_checks.sh"
stdout_files_have_no_errors
