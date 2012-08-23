# Update BASHRC framework on logout.
if [[ -n "$BASHRC" ]]; then
    check=$BASHRC/.check_freq
    freq=$(<$check)
    if [[ -f $check && -n "$(find $check -mtime +${freq:-0})" ]]; then
	set -e -u
	[[ ! -d ${BASHRC?}/.svn ]] || (set -x; svn up --non-interactive $BASHRC)
	[[ ! -d ${BASHRC?}/.git ]] || (set -x; cd $BASHRC && git pull)
	> $check
    fi
fi
