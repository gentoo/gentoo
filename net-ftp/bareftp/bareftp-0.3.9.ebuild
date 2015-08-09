# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit mono gnome2

DESCRIPTION="Mono based file transfer client"
HOMEPAGE="http://www.bareftp.org/"
SRC_URI="http://www.bareftp.org/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome-keyring"

RDEPEND=">=dev-lang/mono-2.0
	>=dev-dotnet/gtk-sharp-2.12
	>=dev-dotnet/gnome-sharp-2.20
	>=dev-dotnet/gnomevfs-sharp-2.20
	>=dev-dotnet/gconf-sharp-2.20
	gnome-keyring? ( >=dev-dotnet/gnome-keyring-sharp-1.0.0-r2 )"
DEPEND="${RDEPEND}"

pkg_setup() {
	DOCS="AUTHORS ChangeLog CREDITS README"
	G2CONF="--disable-caches
		--disable-static
		$(use_with gnome-keyring gnomekeyring)"
}
