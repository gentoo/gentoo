# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib

DESCRIPTION="a fancy but useless dockapp with moving blobs"
HOMEPAGE="https://github.com/bbidulock/wmblob"
SRC_URI="https://github.com/bbidulock/wmblob/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-libs/libXt"

DOCS="AUTHORS ChangeLog NEWS README doc/how_it_works"

src_prepare() {
	default

	sed -i \
		-e "s|-O2|${CFLAGS}|g" \
		-e "s|\$x_libraries|/usr/$(get_libdir)|" \
		configure.ac || die

	eautoreconf
}
