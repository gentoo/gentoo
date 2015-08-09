# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Blat-like Fast Accurate Search Tool"
HOMEPAGE="https://sourceforge.net/projects/bfast/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-perl/XML-Simple"

src_prepare() {
	sed \
		-e 's/-m64//' \
		-e 's/CFLAGS="${default_CFLAGS} ${extended_CFLAGS}"/CFLAGS="${CFLAGS} ${default_CFLAGS} ${extended_CFLAGS}"/' \
		-e 's:-g -O2::g' \
		-i configure.ac || die
	sed \
		-e 's:. test.definitions.sh:. ./test.definitions.sh:g' \
		-i tests/*sh || die

	sed \
		-e '/docdir/d' \
		-i Makefile.am || die

	use test && AUTOTOOLS_IN_SOURCE_BUILD=1

	autotools-utils_src_prepare
}
