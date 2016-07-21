# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2 mono-env

DESCRIPTION="GNOME Do allows you to get things done quickly"
HOMEPAGE="http://do.davebsd.com/"
SRC_URI="https://launchpad.net/do/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="<dev-lang/mono-3
	>=dev-dotnet/gconf-sharp-2.24.0
	>=dev-dotnet/gtk-sharp-2.12.6
	>=dev-dotnet/glade-sharp-2.12.6
	dev-dotnet/ndesk-dbus
	dev-dotnet/ndesk-dbus-glib
	>=dev-dotnet/gnome-desktop-sharp-2.26.0
	>=dev-dotnet/gnome-keyring-sharp-1.0.0
	>=dev-dotnet/gnome-sharp-2.24.0
	>=dev-dotnet/gnomevfs-sharp-2.24.0
	>=dev-dotnet/wnck-sharp-2.24.0
	>=dev-dotnet/art-sharp-2.24.0
	>=dev-dotnet/rsvg-sharp-2.24.0
	dev-dotnet/mono-addins[gtk]
	dev-dotnet/notify-sharp
	!<gnome-extra/gnome-do-plugins-0.8.4"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

#src_prepare() {
#	sed -e 's: -Werror : :' \
#		-i configure.ac || die
#	eautoreconf
#
#	gnome2_src_prepare
#}
