# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils fortran-2 multilib toolchain-funcs

DEB_PN=cernlib
DEB_PV=20061220+dfsg3
DEB_PR=4.3
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="CERN program library for High Energy Physics"
HOMEPAGE="https://cernlib.web.cern.ch/cernlib/"
SRC_URI="
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.debian.tar.xz"

SLOT="0"
LICENSE="GPL-2 LGPL-2 BSD"
KEYWORDS="~amd64 ~hppa ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	x11-libs/motif:0
	virtual/lapack
	dev-lang/cfortran"
DEPEND="${RDEPEND}
	x11-misc/imake
	x11-misc/makedepend
	virtual/pkgconfig"

S="${WORKDIR}/${DEB_PN}-${DEB_PV}"

src_prepare() {
	mv ../debian . || die
	epatch "${FILESDIR}"/${P}-nogfortran.patch
	# set some default paths
	sed -i \
		-e "s:/usr/local:${EROOT}/usr:g" \
		-e "s:prefix)/lib/\$(DEB_HOST_MULTIARCH):prefix)/$(get_libdir):" \
		-e "s:\$(prefix)/etc:${EROOT}/etc:" \
		-e 's:$(prefix)/man:$(prefix)/share/man:' \
		debian/add-ons/cernlib.mk || die "sed failed"

	# use system blas and lapack set by gentoo framework
	sed -i \
		-e "s:\$DEPS -lm:$($(tc-getPKG_CONFIG) --libs blas):" \
		-e "s:\$DEPS -llapack -lm:$($(tc-getPKG_CONFIG) --libs lapack):" \
		-e 's:`depend $d $a blas`::' \
		-e 's:X11R6:X11:g' \
		-e 's: /[^ ]*`dpkg-arch.*`::' \
		debian/add-ons/bin/cernlib.in || die "sed failed"

	cp debian/add-ons/Makefile .
	export DEB_BUILD_OPTIONS="$(tc-getFC) nostrip nocheck"

	einfo "Applying Debian patches"
	emake -j1 patch

	epatch "${FILESDIR}"/${P}-fgets.patch
	epatch "${FILESDIR}"/${P}-ypatchy-short-name.patch
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
		src/patchy/Imakefile \
		|| die "sed for ldflags propagation failed"

	# add missing headers for implicit
	sed -i \
		-e '0,/^#include/i#include <stdlib.h>' \
		src/kernlib/kerngen/ccgen*/*.c || die
}

src_compile() {
	# parallel make breaks and complex patched imake system, hard to debug
	emake -j1 cernlib-indep cernlib-arch
}

src_test() {
	LD_LIBRARY_PATH="${S}"/shlib emake -j1 cernlib-test
}

src_install() {
	default
	cd debian
	dodoc changelog README.* deadpool.txt NEWS copyright
	newdoc add-ons/README README.add-ons
}
