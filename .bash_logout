if [[ -n "$BASHRC" ]]; then
    # Update BASHRC framework on logout. To suppress this entirely:
    # "echo 'days=-1' > ~/.check_freq". To update on every logout
    # make the file empty. Otherwise "echo 'days=N' > ~/.check_freq"
    # to cause it to be updated on logout every N+1 days. Thus
    # 'days=0' will cause an update once per day.
    check=~/.check_freq
    [[ -f $check ]] || check=$BASHRC/.check_freq
    days=
    [[ ! -s $check ]] || source $check
    if [[ -z "$days" || ( $days != -* && -n "$(find $check -mtime +$days)" ) ]]; then
	for dir in $BASHRC $bashrc_logout_update; do
	    [[ ! -d $dir/.svn ]] || (set -ex; svn up --non-interactive $dir)
	    [[ ! -d $dir/.git ]] || (set -ex; cd $dir && git pull)
	done
	[[ ! -s $check ]] || echo days=$days > $check
    fi
fi
