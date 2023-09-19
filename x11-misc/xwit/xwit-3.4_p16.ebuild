# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A collection of simple routines to call some of those X11 functions"
HOMEPAGE="https://tracker.debian.org/pkg/xwit"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*/}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"

LICENSE="public-domain HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
S=${WORKDIR}/${P/_p*/}.orig
PATCHES=( "${WORKDIR}"/debian/patches )

src_prepare() {
	default
	sed -i \
		-e 's|gcc|${CC}|g' \
		Makefile || die
	tc-export CC
}

src_install() {
	dobin xwit
	newman xwit.man xwit.1
	einstalldocs
}
