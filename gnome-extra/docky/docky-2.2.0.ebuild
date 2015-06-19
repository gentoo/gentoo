# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/docky/docky-2.2.0.ebuild,v 1.3 2013/07/04 12:26:08 ago Exp $

EAPI=4
inherit autotools eutils gnome2 mono

DESCRIPTION="Elegant, powerful, clean dock"
HOMEPAGE="https://wiki.go-docky.com"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug nls"

RDEPEND="dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	dev-dotnet/gconf-sharp
	>=dev-dotnet/gio-sharp-0.2-r1
	dev-dotnet/glib-sharp
	dev-dotnet/gnome-desktop-sharp
	dev-dotnet/gnome-keyring-sharp
	dev-dotnet/gtk-sharp
	dev-dotnet/mono-addins[gtk]
	dev-dotnet/notify-sharp
	dev-dotnet/rsvg-sharp
	dev-dotnet/wnck-sharp"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-release
		$(use_enable nls)"

	DOCS="AUTHORS NEWS"
}

src_prepare() {
	sed -i -e "/warnaserror/d" configure.ac || die
	eautoreconf
}
