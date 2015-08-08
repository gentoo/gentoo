# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs games

DEB_PATCH_VER="12"
DESCRIPTION="Mille Bournes card game"
HOMEPAGE="http://www.milleborne.info/"
SRC_URI="mirror://debian/pool/main/x/xmille/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/x/xmille/${PN}_${PV}-${DEB_PATCH_VER}.diff.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/imake"

S=${WORKDIR}/${P}.orig

PATCHES=( "${WORKDIR}"/${PN}_${PV}-${DEB_PATCH_VER}.diff )

src_configure() {
	xmkmf || die
}

src_compile() {
	emake -j1 \
		AR="$(tc-getAR) clq" \
		RANLIB="$(tc-getRANLIB)" \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dogamesbin xmille
	dodoc CHANGES README
	newman xmille.man xmille.6
	prepgamesdirs
}
