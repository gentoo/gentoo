# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/dzip/dzip-2.9-r3.ebuild,v 1.3 2015/04/06 09:25:25 tupone Exp $

EAPI=5
inherit eutils

DESCRIPTION="compressor/uncompressor for demo recordings from id's Quake"
HOMEPAGE="http://speeddemosarchive.com/dzip/"
SRC_URI="http://speeddemosarchive.com/dzip/dz${PV/./}src.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-system-zlib-r2.patch
	epatch "${FILESDIR}"/${P}-scrub-names.patch #93079
	epatch "${FILESDIR}/dzip-amd64.diff"
	mv -f Makefile{.linux,}
}

src_install () {
	dobin dzip
	dodoc Readme
}
