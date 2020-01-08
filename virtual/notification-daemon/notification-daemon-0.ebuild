# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for notification daemon dbus service"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="gnome kde"

RDEPEND="
	gnome? ( || ( x11-misc/notification-daemon
		gnome-base/gnome-shell ) )
	kde? ( kde-plasma/plasma-workspace )
	!gnome? ( !kde? ( || (
		x11-misc/notification-daemon
		gnome-extra/cinnamon
		xfce-extra/xfce4-notifyd
		x11-misc/notify-osd
		x11-misc/dunst
		>=x11-wm/awesome-3.4.4[dbus]
		x11-wm/enlightenment
		x11-misc/mate-notification-daemon
		lxqt-base/lxqt-notificationd
		net-misc/eventd[notification] ) ) )"
