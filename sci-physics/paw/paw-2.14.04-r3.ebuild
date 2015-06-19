# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/paw/paw-2.14.04-r3.ebuild,v 1.4 2015/05/27 15:36:27 bircoph Exp $

EAPI=4

inherit eutils toolchain-funcs fortran-2

DEB_PN=paw
DEB_PV=${PV}.dfsg.2
DEB_PR=7
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="CERN's Physics Analysis Workstation data analysis program"
HOMEPAGE="https://paw.web.cern.ch/paw/"
SRC_URI="
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.debian.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2 BSD"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

RDEPEND="
	sci-physics/cernlib
	x11-libs/libXaw
	>=x11-libs/motif-2.3:0
	x11-libs/xbae"
DEPEND="${RDEPEND}
	dev-lang/cfortran
	virtual/latex-base
	x11-misc/imake
	x11-misc/makedepend"

S="${WORKDIR}/${DEB_PN}-${DEB_PV}.orig"

src_prepare() {
	mv ../debian .  && cp debian/add-ons/Makefile .
	export DEB_BUILD_OPTIONS="$(tc-getFC) nostrip nocheck"

	# fix some path stuff and collision for comis.h,
	# already installed by cernlib and replace hardcoded fortran compiler
	sed -i \
		-e 's:/usr/local:/usr:g' \
		-e '/comis.h/d' \
		-e "s/gfortran/$(tc-getFC)/g" \
		Makefile || die "sed'ing the Makefile failed"

	einfo "Applying Debian patches"
	emake -j1 patch
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	#epatch "${FILESDIR}"/${P}-missing-headers.patch
	# since we depend on cfortran, do not use the one from cernlib
	rm -f src/include/cfortran/cfortran.h
}

src_compile() {
	VARTEXFONTS="${T}"/fonts
	emake -j1 cernlib-indep cernlib-arch
}

src_install() {
	emake DESTDIR="${D}" install
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt copyright
	newdoc add-ons/README README.add-ons
}
