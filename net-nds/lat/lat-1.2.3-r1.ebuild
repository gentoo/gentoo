# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no

inherit gnome2 mono-env

DESCRIPTION="LDAP Administration Tool, allows you to browse LDAP-based directories and add/edit/delete entries"
HOMEPAGE="http://sourceforge.net/projects/ldap-at/"
SRC_URI="mirror://sourceforge/ldap-at/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zeroconf"

RDEPEND="
	>=dev-lang/mono-1.1.13
	>=dev-dotnet/gtk-sharp-2.12.21
	>=dev-dotnet/gnome-sharp-2.24.2-r1
	gnome-base/libgnome-keyring
	sys-apps/dbus
	zeroconf? ( net-dns/avahi[mono] )
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
	econf $(use_enable zeroconf avahi)
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
	if use zeroconf ; then
		ewarn "You've enabled zeroconf support."
		ewarn "Make sure the avahi daemon is running before you try to start ${PN}"
	fi
}
