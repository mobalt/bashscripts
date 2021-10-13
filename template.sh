#!/bin/bash
show_help() {
  cat <<HELPMSG
${APPNAME} ${VERSION} - Short description of what the script does.

usage $0 [OPTION]... [ARGUMENT]...
  --version, -v         Prints the version and exits.
  --help, -h            Print this help message.

HELPMSG
}

APPNAME="ExampleBashScript"
VERSION="0.1.0"

main() {
  echo "Hello world."
}

source common.sh $@
main $@
