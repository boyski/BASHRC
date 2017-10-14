#####################################################################
# DO NOT CHANGE THIS FILE LOCALLY! It provides only a framework
# for finding your own bash config files at ~/.bash-topshell and
# ~/.bash-pershell (or in the equivalent ./USERS/$LOGNAME area if you've
# chosen to version them). Make your customizations to those files.
# Self-referential environment settings like PATH=$PATH:/foo/bar must
# go in topshell, aliases, functions, and unexported shell variables
# belong in pershell, and non-self-referential environment settings
# such as EDITOR=vim can go either place though topshell is preferred.
# See the README in the same directory as this file for details.
#####################################################################

source ${BASH_SOURCE[0]%/*}/BASHRC/bash-init -pershell "$@"
