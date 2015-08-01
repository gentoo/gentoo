# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/cernlib-montecarlo/cernlib-montecarlo-2006-r4.ebuild,v 1.2 2015/08/01 19:02:20 bircoph Exp $

EAPI=5

inherit eutils fortran-2 toolchain-funcs

DEB_PN=mclibs
DEB_PV=20061220+dfsg3
DEB_PR=3
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="Monte-carlo library and tools for the cernlib"
HOMEPAGE="https://cernlib.web.cern.ch/cernlib/"
SRC_URI="
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.debian.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2 BSD"
IUSE="+herwig"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	x11-libs/motif:0
	dev-lang/cfortran
	sci-physics/cernlib
	herwig? ( !sci-physics/herwig )"

DEPEND="${RDEPEND}
	virtual/latex-base
	x11-misc/imake
	x11-misc/makedepend"

S="${WORKDIR}/${DEB_PN}-${DEB_PV}.orig"

src_prepare() {
	mv ../debian . || die
	cp debian/add-ons/Makefile . || die
	export DEB_BUILD_OPTIONS="$(tc-getFC) nostrip nocheck"
	sed -i \
		-e "s:/usr/local:${EROOT}/usr:g" \
		Makefile || die

	einfo "Applying Debian patches"
	emake -j1 patch
	use herwig || epatch "${FILESDIR}"/${P}-noherwig.patch
	# since we depend on cfortran, do not use the one from cernlib
	rm src/include/cfortran/cfortran.h || die
	# respect users flags
	sed -i \
		-e 's/-O3/-O2/g' \
		-e "s/-O2/${CFLAGS}/g" \
		-e "s|\(CcCmd[[:space:]]*\)gcc|\1$(tc-getCC)|g" \
		-e "s|\(CplusplusCmd[[:space:]]*\)g++|\1$(tc-getCXX)|g" \
		-e "s|\(FortranCmd[[:space:]]*\)gfortran|\1$(tc-getFC)|g" \
		src/config/linux.cf	\
		|| die "sed linux.cf failed"
	sed -i \
		-e "s|\(ArCmdBase[[:space:]]*\)ar|\1$(tc-getAR)|g" \
		-e "s|\(RanlibCmd[[:space:]]*\)ranlib|\1$(tc-getRANLIB)|g" \
		src/config/Imake.tmpl	\
		|| die "sed Imake.tmpl failed"

	sed -i \
		-e 's/\$(FCLINK)/\$(FCLINK) $(LDFLAGS)/' \
		-e 's/\$(CCLINK)/\$(CCLINK) $(LDFLAGS)/' \
		src/config/{biglib,fortran,Imake}.rules \
		|| die "sed for ldflags propagation failed"
}

src_compile() {
	export VARTEXFONTS="${T}"/fonts
	emake -j1 cernlib-indep cernlib-arch
}

src_test() {
	export VARTEXFONTS="${T}"/fonts
	LD_LIBRARY_PATH="${S}"/shlib \
		emake -j1 cernlib-test
}

src_install() {
	emake DESTDIR="${D}" MCDOC="${ED}usr/share/doc/${PF}" install
	cd debian
	dodoc changelog README.* deadpool.txt copyright
	newdoc add-ons/README README.add-ons
}
