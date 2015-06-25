# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/d0_blind_id/d0_blind_id-0.5.ebuild,v 1.6 2015/06/25 03:25:18 mr_bones_ Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Blind-ID library for user identification using RSA blind signatures"
HOMEPAGE="http://git.xonotic.org/?p=xonotic/d0_blind_id.git;a=summary"
SRC_URI="mirror://github/divVerent/d0_blind_id/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="dev-libs/gmp:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( d0_blind_id.txt )

src_prepare() {
	# fix out-of-source build
	sed -i \
		-e 's, d0_rijndael.c, "$srcdir/d0_rijndael.c",' \
		configure.ac || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-rijndael
		--without-openssl
		--without-tommath
	)
	autotools-utils_src_configure
}
