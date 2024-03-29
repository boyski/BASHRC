#####################################################################
# THIS FILE SHOULD NOT BE MODIFIED!! It provides only a framework
# for finding your own bash config files at ~/.bash-topshell and
# ~/.bash-pershell (or in the equivalent ./USERS/$LOGNAME area if you've
# chosen to version them). Make your customizations to those files.
# Self-referential environment settings like PATH=$PATH:/foo/bar must
# go in topshell. Aliases, functions, and unexported shell variables
# belong in pershell. Non-self-referential environment settings such
# as EDITOR=vim can go either place though topshell is more elegant.
# See the README in the same directory as this file for details.
#####################################################################

source ${BASH_SOURCE[0]%/*}/BASHRC/bash-init -pershell "$@"

# Keep tabs out since human users can't agree on tabstops.
# This file is marked read-only in vim because it usually shouldn't
# be changed. Use a force-write if the change is legitimate.
# vim: filetype=sh:sw=4:et:tw=80:cc=+1:readonly
