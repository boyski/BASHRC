if [[ -n "$BASHRC" ]]; then
    # Update BASHRC framework on logout. To suppress this entirely,
    # put "-1" into .check_freq or remove it entirely. To check on
    # every logout, make the file empty. Otherwise "echo N > .check_freq"
    # will cause it to be updated on logout every N+1 days.
    check=$BASHRC/.check_freq
    if [[ -f $check ]]; then
	freq=$(<$check)
	if [[ -z "$freq" || ( $freq != -* && -n "$(find $check -mtime +$freq)" ) ]]; then
	    set -e -u
	    [[ ! -d ${BASHRC?}/.svn ]] || (set -x; svn up --non-interactive $BASHRC)
	    [[ ! -d ${BASHRC?}/.git ]] || (set -x; cd $BASHRC && git pull)
	    echo $freq > $check
	fi
    fi
fi
