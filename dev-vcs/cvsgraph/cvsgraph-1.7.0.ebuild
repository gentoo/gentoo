# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CVS/RCS repository grapher"
HOMEPAGE="http://www.akhphd.au.dk/~bertho/cvsgraph"
SRC_URI="http://www.akhphd.au.dk/~bertho/cvsgraph/release/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="gif jpeg nls png truetype zlib"

DEPEND="media-libs/gd
	zlib? ( sys-libs/zlib )
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	jpeg? ( virtual/jpeg )
	truetype? ( media-libs/freetype )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable gif) \
		$(use_enable png) \
		$(use_enable jpeg) \
		$(use_enable truetype)
}

src_install () {
	dobin cvsgraph
	insinto /etc
	doins cvsgraph.conf
	doman cvsgraph.1 cvsgraph.conf.5
	dodoc ChangeLog README AUTHORS contrib/*.php
	dodoc -r contrib/automatic_documentation
}
