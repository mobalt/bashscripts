#!/usr/bin/env bash

show_version() {
  echo "${APPNAME} ${VERSION}"
}
check_help_flags() {
  if [ $# == 0 ] || [ "$1" = '-h' ] || [ "$1" = '--help' ] || [ "$1" = "-?" ]; then
    # This function is provided by the calling script.
    show_help
    exit 1
  elif [ "$1" = '-v' ] || [ "$1" = '--version' ]; then
    show_version
    exit 0
  fi
}

check_help_flags $@
