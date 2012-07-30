# Update BASHRC framework on logout.
set -e -u
[[ ! -d ${BASHRC?}/.svn ]] || (set -x; svn up $BASHRC)
[[ ! -d ${BASHRC?}/.git ]] || (set -x; cd $BASHRC && git pull)
