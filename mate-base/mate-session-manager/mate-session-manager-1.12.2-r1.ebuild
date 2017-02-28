# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="MATE session manager"
HOMEPAGE="http://mate-desktop.org/"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"

IUSE="debug elibc_FreeBSD gnome-keyring gtk3 ipv6 systemd upower"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).

RDEPEND=">=dev-libs/dbus-glib-0.76
	>=dev-libs/glib-2.36:2
	dev-libs/libxslt
	sys-apps/dbus
	x11-apps/xdpyinfo
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/xtrans
	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	virtual/libintl
	elibc_FreeBSD? ( dev-libs/libexecinfo )
	gnome-keyring? ( gnome-base/gnome-keyring )
	!gtk3? ( >=x11-libs/gtk+-2.14:2 )
	gtk3? ( >=x11-libs/gtk+-3.0:3 )
	systemd? ( sys-apps/systemd )
	upower? ( || ( >=sys-power/upower-0.9.23 >=sys-power/upower-pm-utils-0.9.23 ) )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40:*
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40:*
	virtual/pkgconfig:*
	!<gnome-base/gdm-2.20.4"

# Add "session saving" button back,
# see https://bugzilla.gnome.org/show_bug.cgi?id=575544
PATCHES=( "${FILESDIR}"/${PN}-1.12.2-save-session-ui.patch )

MATE_FORCE_AUTORECONF=true

src_configure() {
	mate_src_configure \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_with systemd) \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable upower)
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
	doexe "${FILESDIR}"/15-xdg-data-mate

	# This should be done in MATE too, see Gentoo bug #270852
	doexe "${FILESDIR}"/10-user-dirs-update-mate
}
