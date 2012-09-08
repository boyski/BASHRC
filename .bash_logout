if [[ -n "$BASHRC" ]]; then
    # Update BASHRC framework on logout. To suppress this entirely,
    # put "-1" into .check_freq or remove it entirely. To check on
    # every logout, make the file empty. Otherwise "echo N > .check_freq"
    # will cause it to be updated on logout every N+1 days.
    check=$BASHRC/.check_freq
    days=
    [[ ! -f $check ]] || source $check
    if [[ -z "$days" || ( $days != -* && -n "$(find $check -mtime +$days)" ) ]]; then
	for dir in $BASHRC $bashrc_logout_update; do
	    [[ ! -d $dir/.svn ]] || (set -ex; svn up --non-interactive $dir)
	    [[ ! -d $dir/.git ]] || (set -ex; cd $dir && git pull)
	done
	[[ ! -f $check ]] || echo days=$days > $check
    fi
fi
