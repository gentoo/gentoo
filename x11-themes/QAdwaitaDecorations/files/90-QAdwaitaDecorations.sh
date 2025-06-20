#!/bin/sh
case "$XDG_CURRENT_DESKTOP" in
	*GNOME*)
		export QT_WAYLAND_DECORATION=adwaita
		;;
esac
