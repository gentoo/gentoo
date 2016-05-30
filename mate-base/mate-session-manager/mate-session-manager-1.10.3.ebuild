# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="yes"

inherit autotools gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE session manager"
HOMEPAGE="http://mate-desktop.org/"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="ipv6 elibc_FreeBSD gnome-keyring systemd upower"

# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).

RDEPEND=">=dev-libs/dbus-glib-0.76
	>=dev-libs/glib-2.36:2
	dev-libs/libxslt
	sys-apps/dbus
	x11-apps/xdpyinfo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.14:2
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
	systemd? ( sys-apps/systemd )
	upower? ( || ( >=sys-power/upower-0.9.23 >=sys-power/upower-pm-utils-0.9.23 ) )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40:*
	>=dev-lang/perl-5
	>=mate-base/mate-common-1.10
	>=mate-base/mate-desktop-1.10
	>=sys-devel/gettext-0.10.40:*
	virtual/pkgconfig:*
	!<gnome-base/gdm-2.20.4"

src_prepare() {
	# Add "session saving" button back,
	# see https://bugzilla.gnome.org/show_bug.cgi?id=575544
	epatch "${FILESDIR}"/${PN}-1.5.2-save-session-ui.patch

	# Upstream patch by oleid to fix building with upower 0.99
	epatch "${FILESDIR}"/${PN}-1.10.3-upower-0.99-series.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-gtk=2.0 \
		$(use_enable ipv6) \
		$(use_with systemd) \
		$(use_enable upower)
}

DOCS="AUTHORS ChangeLog NEWS README"

src_install() {
	gnome2_src_install

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
