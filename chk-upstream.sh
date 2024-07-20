#!/bin/bash

######### chk_pkg_upstream.sh #########
# purpose: read version from pacman and git
#          compare and display both
#
# author:  mutoroglin@posteoorg
#
# change-log:
#     v0.1 initial version
#     v1.0 all basic functions implemented
#           -> reads git repository and pacman package name from arguments
#           -> gets git upstream version
#           -> compares version and display result
#     v1.1  -> renamed to chk-upstream (formally chk_pkg_upstream)
#           -> added command line parameter `--git` and `--pacman`#
#     v1.2  -> added command line parameter '-s' & '--string': the string will be
#              compared against the pacman package version

program_version="1.0"
git_repository=""
package_name=""

bold='\033[0;1m'
bg_red='\033[0;41m'
bg_red_bold='\033[0;1;41m'
bg_green='\033[0;30;42m'
bg_green_bold='\033[0;1;30;42m'
clear='\033[0m'

get_version_strings()
{
  if [[ -n $git_repository ]]; then
    git_ver=$(gh release view -R $git_repository 2> /dev/null)
    if [ $? -eq 0 ]; then
      git_ver=$(echo $git_ver | grep -o "tag: [a-z0-9._-]*" | cut -d" " -f2);
    else
      git_ver="repository not found";
    fi
  fi

  pacman_ver=$(pacman -Q $package_name 2>/dev/null)
  if [[ $? -eq 0 ]]; then
    pacman_ver=$(echo $pacman_ver | cut -d" " -f2)
  else
    pacman_ver="pckage not installed"
  fi
}

display_results()
{
  #printf "$string_ver"
  if [[ -n $string_name ]]; then
    cmp_ver=$string_name
    src=string
  else
    cmp_ver=$git_ver
    src=git
  fi

  if [[ $pacman_ver =~ $cmp_ver ]]; then
    printf "${bg_green_bold}package: $package_name   ${bg_green}"
  else
    printf "${bg_red_bold}package: $package_name   ${bg_red}"
  fi
  printf "$src: $cmp_ver, pacman: $pacman_ver${clear}\n"
}

display_usage()
{
printf "\n${bold}chk-upstream${clear} retrieves an upstream version and compares it against a pacman package version\n\n"
printf "Version: $program_version\n\n"
printf "Usage: chk-upstream -g git_repository_name -p package_name\n"
printf "   or: chk-upstream --git git_repository_name --pacman package_name\n"
printf "   or: chk-upstream -s string -p package_name\n"
printf "   or: chk-upstream -h\n"
printf "   or: chk-upstream --help\n\n"
}

verify_parameters()
{
if [[ -z $git_repository ]] && [[ -z $string_name ]]; then
  printf "test"
  printf "provide a git repository\n\n"
  display_usage
  exit 2
fi

if [[ -z $package_name ]]; then
  printf "provide a package name\n\n"
  display_usage
  exit 3
fi
}

### main ###
i=$(($#-1))
while [ $i -ge 0 ];
do
  case ${BASH_ARGV[$i]} in
       -g|--git) i=$((i-1))
           git_repository=${BASH_ARGV[$i]}
           ;;
       -p|--pacman) i=$((i-1))
           package_name=${BASH_ARGV[$i]}
           ;;
       -s|--string) i=$((i-1))
           string_name=${BASH_ARGV[$i]}
           ;;
       -h|--help)
           display_usage
           exit 99
           ;;
       *) printf "Error: given argument(s) is/are unknown\n"
           display_usage
           exit 1
           ;;
  esac
  i=$((i-1))
done

verify_parameters
get_version_strings
display_results

exit 0
