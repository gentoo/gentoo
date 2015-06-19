# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpgf/libpgf-6.12.27.ebuild,v 1.3 2012/10/27 04:24:10 phajdan.jr Exp $

EAPI=4
inherit autotools

DESCRIPTION="Library to load, handle and manipulate images in the PGF format"
HOMEPAGE="http://www.libpgf.org/"
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )
	app-arch/unzip"

src_prepare() {
	if ! use doc; then
		sed -i -e "/HAS_DOXYGEN/{N;N;d}" Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
