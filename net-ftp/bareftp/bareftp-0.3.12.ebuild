# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools mono-env gnome2

DESCRIPTION="Mono based file transfer client"
HOMEPAGE="http://www.bareftp.org/"
SRC_URI="http://www.bareftp.org/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome-keyring"

RDEPEND="
	>=dev-lang/mono-2.0
	>=dev-dotnet/gtk-sharp-2.12
	>=dev-dotnet/gnome-sharp-2.20
	>=dev-dotnet/gnomevfs-sharp-2.20
	>=dev-dotnet/gconf-sharp-2.20
	gnome-keyring? ( >=dev-dotnet/gnome-keyring-sharp-1.0.0-r2 )
"
DEPEND="${RDEPEND}"

src_prepare() {
	# Fixes for build with Mono 4
	sed -i "s#gmcs#mcs#g" configure.ac || die

	eautoreconf
	sed -i "s#mono/2.0#mono/4.5#g" configure || die
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-caches \
		--disable-static \
		$(use_with gnome-keyring gnomekeyring)
}
