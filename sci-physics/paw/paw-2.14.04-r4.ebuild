# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs fortran-2

DEB_PN=paw
DEB_PV=${PV}.dfsg.2
DEB_PR=8
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="CERN's Physics Analysis Workstation data analysis program"
HOMEPAGE="https://paw.web.cern.ch/paw/"
SRC_URI="
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.debian.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2 BSD"
KEYWORDS="amd64 hppa sparc x86 ~amd64-linux ~x86-linux"
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
	mv ../debian . && cp debian/add-ons/Makefile .
	export DEB_BUILD_OPTIONS="$(tc-getFC) nostrip nocheck"

	# fix some path stuff and collision for comis.h,
	# already installed by cernlib and replace hardcoded fortran compiler
	sed -i \
		-e "s:/usr/local:${EROOT}/usr:g" \
		-e '/comis.h/d' \
		-e "s/gfortran/$(tc-getFC)/g" \
		Makefile || die

	einfo "Applying Debian patches"
	emake -j1 patch
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	# since we depend on cfortran, do not use the one from cernlib
	rm src/include/cfortran/cfortran.h || die
	sed -i \
		-e "s|\(ArCmdBase[[:space:]]*\)ar|\1$(tc-getAR)|g" \
		-e "s|\(RanlibCmd[[:space:]]*\)ranlib|\1$(tc-getRANLIB)|g" \
		src/config/Imake.tmpl	\
		|| die "sed Imake.tmpl failed"
}

src_compile() {
	VARTEXFONTS="${T}"/fonts
	emake -j1 cernlib-indep cernlib-arch
}

src_install() {
	default
	cd debian
	dodoc changelog README.* deadpool.txt copyright
	newdoc add-ons/README README.add-ons
}
