if [[ -n "$BASHRC" ]]; then
    # Update BASHRC framework on logout. To suppress this entirely:
    # "echo 'days=-1' > ~/.check_freq". To update on every logout
    # make the file empty. Otherwise "echo 'days=N' > ~/.check_freq"
    # to cause it to be updated on logout every N+1 days. Thus
    # 'days=0' will cause an update once per day.
    # Must be careful because svn versions often differ across platforms
    # and trying to update an svn X checkout with svn Y would break.
    check=~/.check_freq
    [[ -f $check ]] || check=$BASHRC/.check_freq
    days=
    [[ ! -s $check ]] || source $check
    if [[ -z "$days" || ( $days != -* && -n "$(find $check -mtime +$days)" ) ]]; then
	for dir in $BASHRC $bashrc_logout_update; do
	    if test -d $dir/.svn && svn info $dir >/dev/null 2>&1; then
		(set -ex; svn up --non-interactive $dir)
	    fi
	    [[ ! -d $dir/.git ]] || (set -ex; builtin cd $dir && git pull)
	done
	[[ ! -s $check ]] || echo days=$days > $check
    fi
fi

# Retain shell history data for a while if we're keeping it in memory.
if [[ -d ~/.bash_history && -w ~/.bash_history ]]; then
    find ~/.bash_history ! -mtime -10 -type f -exec rm -f {} +
    echo "#$(pwd)" > ~/.bash_history/history.$$
    history >> ~/.bash_history/history.$$
fi
