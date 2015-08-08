# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic

DESCRIPTION="sexyPSF is an open-source PSF1 (Playstation music) file player"
HOMEPAGE="http://projects.raphnet.net/#sexypsf"
SRC_URI="http://projects.raphnet.net/sexypsf/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

#-sparc: 0.4.5: Couldn't load minispf
KEYWORDS="amd64 ppc -sparc x86"
IUSE=""

DEPEND="sys-libs/zlib"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-misc.patch

	# ppc and sparc are big-endian while all other keywords are
	# little-endian (as far as I know)
	use ppc64 || use ppc || use sparc &&
	sed -i -e "s:-D__LINUX__:& -DMSB_FIRST:" "${S}"/Linux/Makefile
	# what about using the correct macro and avoid to cause severe damages to
	# innocent ears?
	sed -i -e "s:AFMT_S16_LE:AFMT_S16_NE:" "${S}"/Linux/oss.c
}

src_compile() {
	cd "${S}"/Linux
	emake || die "emake failed"
}

src_install() {
	dobin Linux/sexypsf
	dodoc Docs/*
}
