# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="MATE session manager"
HOMEPAGE="https://mate-desktop.org/"

LICENSE="GPL-2+ GPL-3+ HPND LGPL-2+ LGPL-2.1+"
SLOT="0"
IUSE="debug elogind gnome-keyring ipv6 systemd +xtrans"

REQUIRED_USE="?? ( elogind systemd )"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.76
	>=dev-libs/glib-2.50:2
	dev-libs/libxslt
	sys-apps/dbus
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
	systemd? ( sys-apps/systemd )
	!systemd? (
		elogind? ( sys-auth/elogind )
		!elogind? ( >=sys-auth/consolekit-0.9.2 )
	)
	xtrans? ( x11-libs/xtrans )"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
	x11-apps/xdpyinfo
	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	gnome-keyring? ( gnome-base/gnome-keyring )
	!<gnome-base/gdm-2.20.4"

DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8:*
	virtual/pkgconfig"

MATE_FORCE_AUTORECONF=true

src_configure() {
	mate_src_configure \
		$(use_with elogind) \
		$(use_with systemd) \
		$(use_with xtrans)  \
		$(use_enable debug) \
		$(use_enable ipv6)
}

src_install() {
	mate_src_install

	dodir /etc/X11/Sessions/
	exeinto /etc/X11/Sessions/
	doexe "${FILESDIR}"/MATE

	dodir /usr/share/mate/applications/
	insinto /usr/share/mate/applications/
	doins "${FILESDIR}"/defaults.list

	dodir /etc/X11/xinit/xinitrc.d/
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}"/15-xdg-data-mate-r1 15-xdg-data-mate

	# This should be done in MATE too, see Gentoo bug #270852
	newexe "${FILESDIR}"/10-user-dirs-update-mate-r1 10-user-dirs-update-mate
}
