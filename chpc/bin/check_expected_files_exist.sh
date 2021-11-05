#!/usr/bin/env bash

show_help() {
  cat <<HELPMSG
${APPNAME} ${VERSION} - checks that all expected files exist.

usage [var1=value1 [var2=value2]]  $0 EXPECTED_FILE_LIST [CHECK_DIR]
  --version, -v         Prints the version and exits.
  --help, -h            Print this help message.

HELPMSG
}

APPNAME="CheckExpectedFilesExist"
VERSION="0.1.0"

exists() {
  local file="$1"
  if [ -e "$file" ]; then
    echo "OKAY:  $file"
  else
    echo "ERROR: $file"
    ((missing_files++))
  fi
}

check_all_expected_files_exist() {
  # Replacements in order do the following:
  # - strip comments (#)
  # - remove empty lines
  # - replace {scan} or {subjectid} with variable ${scan}, while leaving {a,b} alone
  # - replace spaces (" ") with path seperator ("/")
  sed -e 's/#.*//' \
    -e '/^\s*$/d' \
    -e 's/\({[a-zA-Z0-9_-]\+}\)/$\1/g' \
    -e 's# #/#g' \
    $EXPECTED_FILE_LIST |
    while read line; do

      # eval is being used to allow advanced glob patterns
      eval "exists $line"
    done
}

verify_expectedfilelist_exists() {
  EXPECTED_FILE_LIST=$(realpath "$1")
  if [ ! -f "${EXPECTED_FILE_LIST}" ]; then
    echo "The list of expected files does not exist at : ${EXPECTED_FILE_LIST}" >&2
    exit 1
  fi
}

verify_check_dir_exists() {
  CHECK_DIR="${1:-.}"
  if [ ! -d "$CHECK_DIR" ]; then
    echo "The directory does not exist: ${CHECK_DIR}" >&2
    exit 1
  fi
}

main() {
  verify_expectedfilelist_exists $1
  verify_check_dir_exists $2

  pushd "$CHECK_DIR"
  missing_files=0
  check_all_expected_files_exist
  export missing_files
  popd

  if [ $missing_files -ne 0 ]; then
    echo "File Check was unsuccessful. There are $missing_files file(s) missing."
    exit 1
  else
    echo "All expected files are present."
    exit 0
  fi
}

source ../../common.sh $@
main $@
