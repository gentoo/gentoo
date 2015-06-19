# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/geant/geant-3.21.14-r2.ebuild,v 1.23 2015/05/27 14:57:09 bircoph Exp $

EAPI=2

inherit eutils fortran-2

DEB_PN=geant321
DEB_PV=${PV}.dfsg
DEB_PR=8
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="CERN's detector description and simulation Tool"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.diff.gz"

SLOT="3"
LICENSE="GPL-2 LGPL-2 BSD"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-lang/cfortran
	sci-physics/cernlib
	sci-physics/paw
	x11-libs/motif:0"
DEPEND="${RDEPEND}
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
	sed \
		-e 's:/usr/local:/usr:g' \
		-i Makefile || die "sed'ing the Makefile failed"

	einfo "Applying Debian patches"
	emake -j1 patch || die "debian patch failed"

	# since we depend on cfortran, do not use the one from cernlib
	rm -f src/include/cfortran/cfortran.h
}

src_compile() {
	# create local LaTeX cache directory
	VARTEXFONTS="${T}"/fonts
	emake -j1 cernlib-indep cernlib-arch || die "emake failed"
}

src_test_() {
	LD_LIBRARY_PATH="${S}"/shlib \
		emake -j1 cernlib-test || die "emake test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt NEWS copyright || die "dodoc failed"
	newdoc add-ons/README README.add-ons || die "newdoc failed"
}
