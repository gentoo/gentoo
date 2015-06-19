# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/cvsgraph/cvsgraph-1.6.1.ebuild,v 1.3 2012/05/13 21:19:17 ramereth Exp $

DESCRIPTION="CVS/RCS repository grapher"
HOMEPAGE="http://www.akhphd.au.dk/~bertho/cvsgraph"
SRC_URI="http://www.akhphd.au.dk/~bertho/cvsgraph/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha amd64 -ia64 ppc sparc x86"
IUSE="gif jpeg nls png truetype zlib"

DEPEND="media-libs/gd
	zlib? ( sys-libs/zlib )
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	jpeg? ( virtual/jpeg )
	truetype? ( media-libs/freetype )"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable gif) \
		$(use_enable png) \
		$(use_enable jpeg) \
		$(use_enable truetype) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install () {
	dobin cvsgraph
	insinto /etc
	doins cvsgraph.conf
	doman cvsgraph.1 cvsgraph.conf.5
	dodoc ChangeLog README contrib/*.php3
	docinto automatic_documentation ; dodoc contrib/automatic_documentation/*
}
