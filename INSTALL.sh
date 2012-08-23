#!/bin/bash

# This is a script to install the new bash config file design.
# It will not destroy any data but may move ~/.bash_profile
# and ~/.bashrc aside.

now=$(date +%F)

rcdir=$(cd $(dirname $0) && pwd)
rcdir=${rcdir#${HOME?}/*}
: ${rcdir?}

cd ${HOME?}

echo "This will install the 'BASHRC' config files to $HOME."
echo "It will not destroy any files but may rename ~/.bash_profile"
echo "to ~/.bash_profile.$now and ~/.bashrc to ~/.bashrc.$now."
echo "You may also need to tweak the resulting configuration."
echo -n "Do you want to continue? [Y/n] "
read resp
if [[ -n "$resp" && "$resp" != [yY]* ]]; then
    exit 0
fi
echo

if [[ -w ~/.bash_history || ! -e ~/.bash_history ]]; then
    echo "Unsaved, per-invocation shell history is safer, especially for pseudo-users."
    echo -n "Do you want per-shell history? [Y/n] "
    read resp
    if [[ -z "$resp" || "$resp" == [yY]* ]]; then
	echo "# Using per-shell history (safer, especially for pseudo-users)" > ~/.bash_history
	echo "# Make this file writeable to revert to default history behavior" >> ~/.bash_history
	chmod 400 ~/.bash_history
    fi
    echo
fi

bak=PRE-BASHRC

topshell=~/.bash-topshell
if [[ -e ~/.bash_profile ]]; then
    if [[ ! -h ~/.bash_profile && ! -e ~/.bash_profile.$now ]]; then
	(set -x; cp -p ~/.bash_profile ~/.bash_profile.$now)
	(set -x; cp -p ~/.bash_profile ~/.bash_profile.$bak)
    fi
    if [[ -e $topshell ]]; then
	echo "$topshell already present" >&2
    else
	echo "Add your inheritable settings to $topshell" >&2
    fi
fi
[[ -e $topshell ]] || (set -x; cp $rcdir/USERS/example/topshell $topshell)
(set -x; ln -sf $rcdir/.bash_profile .bash_profile)

pershell=~/.bash-pershell
if [[ -e ~/.bashrc ]]; then
    if [[ ! -h ~/.bashrc && ! -e ~/.bashrc.$now ]]; then
	(set -x; cp -p ~/.bashrc ~/.bashrc.$now)
	(set -x; cp -p ~/.bashrc ~/.bashrc.$bak)
    fi
    if [[ -e $pershell ]]; then
	echo "$pershell already present" >&2
    else
	echo "Add your per-shell settings to $pershell" >&2
    fi
fi
[[ -e $pershell ]] || (set -x; cp $rcdir/USERS/example/pershell $pershell)
(set -x; ln -sf $rcdir/.bash_profile .bashrc)

if [[ -e .bash_logout ]]; then
    grep BASHRC .bash_logout >/dev/null || {
	(set -x; echo 'source $BASHRC/.bash_logout' >> .bash_logout)
    }
else
    (set -x; ln -sf $rcdir/.bash_logout .bash_logout)
fi

for i in ~/.bash_login ~/.profile; do
    if [[ -e $i ]]; then
	echo "Warning: $i present but unused, best cleaned up" >&2
    fi
done

cat <<EOF

NOW EXAMINE .bash*.$now AND MOVE SETTINGS INTO .bash-{top,per}shell.
TO ROLL BACK:
    % rm -f .bashrc .bash_profile
    % mv .bashrc.$now .bashrc
    % mv .bash_profile.$now .bash_profile
YOU MAY ALSO FIND A USE FOR SOME OF THE FUNCTIONS in $rcdir/func.

*********************************************************************
TRY LOGGING IN WITH THE NEW ENVIRONMENT _BEFORE_ EXITING THIS SHELL!
*********************************************************************
EOF