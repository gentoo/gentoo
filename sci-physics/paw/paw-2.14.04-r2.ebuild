# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/paw/paw-2.14.04-r2.ebuild,v 1.23 2015/05/27 15:36:27 bircoph Exp $

EAPI=2

inherit eutils fortran-2 toolchain-funcs

DEB_PN=paw
DEB_PV=${PV}.dfsg.2
DEB_PR=6
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="CERN's Physics Analysis Workstation data analysis program"
HOMEPAGE="https://paw.web.cern.ch/paw/"
SRC_URI="
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.diff.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2 BSD"
KEYWORDS="amd64 hppa sparc x86"
IUSE="static"

RDEPEND="
	sci-physics/cernlib
	x11-libs/libXaw
	x11-libs/motif:0
	x11-libs/xbae"
DEPEND="${RDEPEND}
	dev-lang/cfortran
	virtual/latex-base
	x11-misc/imake
	x11-misc/makedepend"

S="${WORKDIR}/${DEB_PN}-${DEB_PV}.orig"

src_prepare() {
	cd "${WORKDIR}"
	sed -i -e 's:/tmp/dp.*/cern:cern:g' ${DEB_P}-${DEB_PR}.diff || die
	epatch ${DEB_P}-${DEB_PR}.diff
	cd "${S}"
	cp debian/add-ons/Makefile .
	export DEB_BUILD_OPTIONS="$(tc-getFC) nostrip nocheck"

	# fix some path stuff and collision for comis.h,
	# already installed by cernlib and replace hardcoded fortran compiler
	sed -i \
		-e 's:/usr/local:/usr:g' \
		-e '/comis.h/d' \
		-e "s/gfortran/$(tc-getFC)/g" \
		Makefile || die "sed'ing the Makefile failed"

	einfo "Applying Debian patches"
	emake -j1 patch || die "applying patch failed"
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	epatch "${FILESDIR}"/${P}-missing-headers.patch
	# since we depend on cfortran, do not use the one from cernlib
	rm -f src/include/cfortran/cfortran.h
}

src_compile() {
	VARTEXFONTS="${T}"/fonts
	emake -j1 cernlib-indep cernlib-arch || die "emake failed"
}

src_install() {
	use static || rm -vf bin/*.static
	emake DESTDIR="${D}" install || die "emake install failed"
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt copyright || die "dodoc failed"
	newdoc add-ons/README README.add-ons || die "newdoc failed"
}
