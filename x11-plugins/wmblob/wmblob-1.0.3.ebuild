# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmblob/wmblob-1.0.3.ebuild,v 1.10 2014/08/10 20:04:54 slyfox Exp $

EAPI=5
inherit autotools multilib

DESCRIPTION="a fancy but useless dockapp with moving blobs"
HOMEPAGE="http://freshmeat.net/projects/wmblob"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	x11-libs/libXt"

DOCS="AUTHORS ChangeLog NEWS README doc/how_it_works"

src_prepare() {
	sed -i \
		-e "s:-O2:${CFLAGS}:g" \
		-e "s:\$x_libraries:/usr/$(get_libdir):" \
		configure.ac || die

	eautoreconf
}
