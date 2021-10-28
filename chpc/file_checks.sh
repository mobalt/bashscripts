#!/usr/bin/env bash
files_contain_pattern() {
  ## Usage: files_contain_pattern <fileglob> <pattern>
  ## Checks if the files contains the pattern.
  ## Arguments:
  ##  fileglob  - a glob describing the files to check
  ##  pattern - a grep compatible search pattern to check for
  ## Returns:
  ##  0 - if the pattern is found in **all** files
  ##  1 - if the pattern is found in **any** file

  local filename="$1"
  local pattern="$2"
  local expected_result="${3:-0}"

  total_count=0
  success_count=0
  fail_count=0
  success=""
  fail=""
  for file in $(find . -type f -path "$filename" | sort); do
    grep -q "$pattern" $file
    if [ $? -eq $expected_result ]; then
      success="$success    $file\n"
      ((success_count++))
    else
      fail="$fail    $file\n"
      ((fail_count++))
    fi
    ((total_count++))
  done

  if [ $fail_count -eq 0 ]; then
    echo "All $total_count files were successful against the pattern \"$pattern\""
    return 0
  else
    echo -e "Failed files:\n$fail"
    echo "Total: $total_count, Success: $success_count, Failed: $fail_count"
    return 1
  fi
}

files_exclude_pattern() {
  ## Usage: files_exclude_pattern <fileglob> <pattern>
  ## Checks if the files do not contain the pattern.
  ## Arguments:
  ##  fileglob  - a glob describing the files to check
  ##  pattern - a grep compatible search pattern to check for
  ## Returns:
  ##  0 - if the pattern is found in **none** of the files
  ##  1 - if the pattern is found in **any** file
  files_contain_pattern "$1" "$2" 1
}
