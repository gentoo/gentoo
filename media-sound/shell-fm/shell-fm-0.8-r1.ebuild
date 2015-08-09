# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="A lightweight console based player for Last.FM radio streams"
HOMEPAGE="http://nex.scrapping.cc/shell-fm/"
SRC_URI="https://github.com/jkramer/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux"
IUSE=""

RDEPEND="media-libs/libao
	media-libs/libmad
	media-libs/taglib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/sed"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-doublefree.patch #392413

	sed -i -e 's:-Os::' source/Makefile || die

	tc-export CC AR
	use ppc && append-flags -DWORDS_BIGENDIAN=1
}

src_install() {
	dobin source/${PN}
	doman manual/${PN}.1
	exeinto /usr/share/${PN}/scripts
	doexe scripts/{*.sh,*.pl,zcontrol}
}
