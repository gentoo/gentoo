# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/wfmath/wfmath-1.0.1.ebuild,v 1.3 2012/12/26 01:24:46 jdhore Exp $

EAPI=4
DESCRIPTION="Worldforge math library"
HOMEPAGE="http://www.worldforge.org/dev/eng/libraries/wfmath"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_compile() {
	emake
	if use doc; then
		emake -C doc docs
	fi
}

src_install() {
	default
	if use doc; then
		dohtml doc/html/*
	fi
	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -exec rm {} + \
			|| die "la removal failed"
	fi
}
