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

    # It's unknown who creates these or why but clean them up occasionally.
    if [[ -d $BASHRC/USERS/$LOGNAME/config/abrt ]]; then
        find $BASHRC/USERS/$LOGNAME/config/abrt ! -atime -2 -type f -exec rm -f {} +
    fi
fi

# Retain shell history data for a while if we're keeping it in memory.
if [[ -d ~/.bash_history && -w ~/.bash_history ]]; then
    find ~/.bash_history ! -mtime -10 -type f -exec rm -f {} +
    echo "#$(pwd)" > ~/.bash_history/history.$$
    history >> ~/.bash_history/history.$$
fi

# Protection in case permissions required for ssh get messed up.
if [[ -d ~/.ssh ]]; then
    chmod go-w ~
    chmod 700 ~/.ssh/
    chmod 600 ~/.ssh/{authorized_keys,config,id_?sa}
    chmod 644 ~/.ssh/id_?sa.pub
fi

# vim: filetype=sh:sw=4:et:
