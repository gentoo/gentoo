# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gramofile/gramofile-1.6_p9.ebuild,v 1.1 2015/01/26 10:41:57 jer Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="Transfer sound from gramophone records to CD"
HOMEPAGE="http://www.opensourcepartners.nl/~costar/gramofile"
SRC_URI="
	mirror://debian/pool/main/g/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/g/${PN}/${PN}_${PV/_p*}-${PV/*_p}.diff.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	sys-libs/ncurses
	sci-libs/fftw:2.1
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${P/_p*}

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${PV/_p*}-${PV/*_p}.diff
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch ${P/_p*}/debian/patches

	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-strlen_and_exit.patch

	tc-export CC PKG_CONFIG
}

src_install() {
	dobin ${PN}
	exeinto /usr/$(get_libdir)/${PN}
	doexe bplay_gramo brec_gramo
	dodoc ChangeLog README TODO *.txt
	newdoc ${P/_p*}/debian/changelog ChangeLog.debian
}
