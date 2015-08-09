# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
GCONF_DEBUG=no

inherit gnome2 mono versionator

KEYWORDS="amd64 x86"

DESCRIPTION="LDAP Administration Tool, allows you to browse LDAP-based directories and add/edit/delete entries"
HOMEPAGE="http://sourceforge.net/projects/ldap-at/"
SRC_URI="mirror://sourceforge/ldap-at/${P}.tar.gz"
LICENSE="GPL-2"
IUSE="avahi"
SLOT="0"

RDEPEND="
	>=dev-lang/mono-1.1.13
	>=dev-dotnet/gtk-sharp-2.8
	>=dev-dotnet/gnome-sharp-2.8
	>=dev-dotnet/glade-sharp-2.8
	>=dev-dotnet/gconf-sharp-2.8
	gnome-base/libgnome-keyring
	sys-apps/dbus
	avahi? ( net-dns/avahi[mono] )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	virtual/pkgconfig"

src_prepare() {
	# Fix tests, bug #295889
	echo lat/plugins/ActiveDirectoryCoreViews/dialogs.glade >> po/POTFILES.in
	echo lat/plugins/JpegAttributeViewer/dialog.glade >> po/POTFILES.in
	echo lat/plugins/PosixCoreViews/dialogs.glade >> po/POTFILES.in
}

src_configure() {
	econf $(use_enable avahi)
}

src_compile() {
	# bug #330203
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use avahi ; then
		ewarn "You've enabled avahi support."
		ewarn "Make sure the avahi daemon is running before you try to start ${PN}"
	fi
}
