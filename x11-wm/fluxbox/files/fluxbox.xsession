#!/bin/sh
# Fluxbox Xsession starter, based on Xsession shipped by x11-apps/xinit-1.0.5-r1

# redirect errors to a file in user's home directory if we can
for errfile in "$HOME/.fluxbox-errors" "${TMPDIR-/tmp}/fluxbox-$USER" "/tmp/fluxbox-$USER"
do
	if ( cp /dev/null "$errfile" 2> /dev/null )
	then
		chmod 600 "$errfile"
		exec > "$errfile" 2>&1
		break
	fi
done

userresources=$HOME/.Xresources 
usermodmap=$HOME/.Xmodmap 
userxkbmap=$HOME/.Xkbmap

sysresources=/etc/X11/Xresources 
sysmodmap=/etc/X11/Xmodmap 
sysxkbmap=/etc/X11/Xkbmap

rh6sysresources=/etc/X11/xinit/Xresources 
rh6sysmodmap=/etc/X11/xinit/Xmodmap 


# merge in defaults
if [ -f "$rh6sysresources" ]; then
    xrdb -merge "$rh6sysresources"
fi

if [ -f "$sysresources" ]; then
    xrdb -merge "$sysresources"
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# merge in keymaps
if [ -f "$sysxkbmap" ]; then
    setxkbmap `cat "$sysxkbmap"`
    XKB_IN_USE=yes
fi

if [ -f "$userxkbmap" ]; then
    setxkbmap `cat "$userxkbmap"`
    XKB_IN_USE=yes
fi

#
# Eeek, this seems like too much magic here
#
if [ -z "$XKB_IN_USE" -a ! -L /etc/X11/X ]; then
    if grep '^exec.*/Xsun' /etc/X11/X > /dev/null 2>&1 && [ -f /etc/X11/XF86Config ]; then
       xkbsymbols=`sed -n -e 's/^[     ]*XkbSymbols[   ]*"\(.*\)".*$/\1/p' /etc/X11/XF86Config /etc/X11/xorg.conf`
       if [ -n "$xkbsymbols" ]; then
           setxkbmap -symbols "$xkbsymbols"
           XKB_IN_USE=yes
       fi
    fi
fi

# xkb and xmodmap don't play nice together
if [ -z "$XKB_IN_USE" ]; then
    if [ -f "$rh6sysmodmap" ]; then
       xmodmap "$rh6sysmodmap"
    fi

    if [ -f "$sysmodmap" ]; then
       xmodmap "$sysmodmap"
    fi

    if [ -f "$usermodmap" ]; then
       xmodmap "$usermodmap"
    fi
fi

unset XKB_IN_USE

# run all system xinitrc shell scripts.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for i in /etc/X11/xinit/xinitrc.d/* ; do
        if [ -x "$i" ]; then
	    . "$i"
        fi
    done
fi

exec /usr/bin/startfluxbox
