# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/dzip/dzip-2.9-r1.ebuild,v 1.5 2012/12/17 13:39:30 ulm Exp $

inherit eutils toolchain-funcs games

DESCRIPTION="compressor/uncompressor for demo recordings from id's Quake"
HOMEPAGE="http://speeddemosarchive.com/dzip/"
SRC_URI="http://speeddemosarchive.com/dzip/dz${PV/./}src.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/dzip-2.9-scrub-names.patch #93079
}

src_compile() {
	emake \
		-f Makefile.linux \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		|| die "emake failed"
}

src_install () {
	dogamesbin dzip || die "dogamesbin failed"
	dodoc Readme || die "dodoc failed"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "Demo files can be found at http://planetquake.com/sda/"
	elog "and http://planetquake.com/qdq/"
	echo
}
