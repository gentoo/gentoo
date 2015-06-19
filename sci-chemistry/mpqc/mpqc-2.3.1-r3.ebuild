# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/mpqc/mpqc-2.3.1-r3.ebuild,v 1.8 2013/02/27 14:38:40 jlec Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils toolchain-funcs

DESCRIPTION="The Massively Parallel Quantum Chemistry Program"
HOMEPAGE="http://www.mpqc.org/"
SRC_URI="mirror://sourceforge/mpqc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc mpi threads static-libs tk"

RDEPEND="
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[cxx] )
	tk? ( dev-lang/tk )"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-devel/flex
	sys-apps/sed
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz )"

PATCHES=(
		"${FILESDIR}"/${P}-as-needed.patch
		"${FILESDIR}"/${P}-respect-ldflags.patch
		"${FILESDIR}"/${P}-test-failure-hack.patch
		"${FILESDIR}"/${P}-blas.patch
	)

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=(CHANGES CITATION README)

src_prepare() {
	# do not install tkmolrender if not requested
	if ! use tk; then
		sed \
			-e "s:.*/bin/molrender/tkmolrender.*::" \
			-e "s:.*\$(INSTALLBINOPT) tkmolrender.*::" \
			-e "s:/bin/rm -f tkmolrender::" \
			-i "./src/bin/molrender/Makefile" \
			|| die "failed to disable tkmolrender"
	fi
	autotools-utils_src_prepare
}

src_configure() {
	tc-export CC CXX
	if use mpi; then
		export CC=mpicc
		export CXX=mpicxx
	fi
	local myeconfargs=(
		$(use_enable threads)
		$(use_enable mpi parallel) )

	autotools-utils_src_configure
	sed \
		-e "s:^CFLAGS =.*$:CFLAGS=${CFLAGS}:" \
		-e "s:^FFLAGS =.*$:FFLAGS=${FFLAGS:- -O2}:" \
		-e "s:^CXXFLAGS =.*$:CXXFLAGS=${CXXFLAGS}:" \
		-i lib/LocalMakefile || die
}

src_test() {
	cd "${AUTOTOOLS_BUILD_DIR}"/src/bin/mpqc/validate

	# we'll only run the small test set, since the
	# medium and large ones take >10h and >24h on my
	# 1.8Ghz P4M
	emake -j1 check1
}

src_install() {
	autotools-utils_src_install installroot="${D}" install install_devel install_inc

	# make extended docs
	if use doc; then
		cd "${AUTOTOOLS_BUILD_DIR}"/doc
		emake -j1 all
		doman man/man1/* man/man3/*
		dohtml -r html
	fi
}

pkg_postinst() {
	echo
	einfo "MPQC can be picky with regard to compilation flags."
	einfo "If during mpqc runs you have trouble converging or "
	einfo "experience oscillations during SCF interations, "
	einfo "consider recompiling with less aggressive CFLAGS/CXXFLAGS."
	einfo "Particularly, replacing -march=pentium4 by -march=pentium3"
	einfo "might help if you encounter problems with correlation "
	einfo "consistent basis sets."
	echo
}
