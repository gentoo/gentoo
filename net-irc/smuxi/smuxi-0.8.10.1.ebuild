# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/smuxi/smuxi-0.8.10.1.ebuild,v 1.5 2014/08/10 20:53:50 slyfox Exp $

EAPI=4
inherit base mono eutils

DESCRIPTION="A flexible, irssi-like and user-friendly IRC client for the Gnome Desktop"
HOMEPAGE="http://www.smuxi.org/main/"
SRC_URI="http://www.smuxi.org/jaws/data/files/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus debug gnome libnotify spell"
LICENSE="|| ( GPL-2 GPL-3 )"

RDEPEND=">=dev-lang/mono-2.0
	>=dev-dotnet/smartirc4net-0.4.5.1
	>=dev-dotnet/nini-1.1.0-r2
	>=dev-dotnet/log4net-1.2.10-r2
	dbus? (	dev-dotnet/dbus-sharp
		dev-dotnet/dbus-sharp-glib
		dev-dotnet/ndesk-dbus
		dev-dotnet/ndesk-dbus-glib )
	gnome? ( >=dev-dotnet/gtk-sharp-2.12
		 >=dev-dotnet/glade-sharp-2.12
		 >=dev-dotnet/glib-sharp-2.12 )
	libnotify? ( dev-dotnet/notify-sharp )
	spell? ( >=app-text/gtkspell-2.0.9:2 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.25
	>=sys-devel/gettext-0.17
	virtual/pkgconfig"

DOCS="FEATURES TODO README"

src_configure() {
# Our dev-dotnet/db4o is completely unmaintained
	econf	--enable-engine-irc		\
		--without-indicate		\
		--with-vendor-package-version="Gentoo ${PV}" \
		--with-db4o=included \
		$(use_enable debug)		\
		$(use_enable gnome frontend-gnome) \
		$(use_with libnotify notify) \
		$(use_with spell gtkspell)
}
