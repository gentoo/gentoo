# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Library and headers for Wnn7 client"
HOMEPAGE="http://www.omronsoft.co.jp/SP/download/pcunix/sdk.html"
SRC_URI="ftp://ftp.omronsoft.co.jp/pub/Wnn7/sdk_source/Wnn7SDK.tgz"

LICENSE="freedist"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

# x11 is required for imake
DEPEND="x11-misc/imake"
RDEPEND=""

S="${WORKDIR}/src"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PN}-malloc.patch"
	epatch "${FILESDIR}/${PN}-gentoo.patch"
	epatch "${FILESDIR}/${PN}-gcc4.patch"
}

src_compile() {
	make World -f Makefile.ini || die "make World failed"
}

src_install() {
	cd ${S}/Wnn/jlib
	dolib.so *.so* || die
	dolib.a  *.a   || die

	cd ${S}/Wnn/include
	insinto /usr/include/${PN}/wnn
	doins *.h || die

	dodoc ${S}/README
}
