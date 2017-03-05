# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="The Massively Parallel Quantum Chemistry Program"
HOMEPAGE="http://www.mpqc.org/"
SRC_URI="mirror://sourceforge/mpqc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc mpi threads static-libs tk"

RDEPEND="
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[cxx] )
	tk? ( dev-lang/tk:0 )"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-devel/flex
	sys-apps/sed
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz )"

PATCHES=(
	"${FILESDIR}/${P}-as-needed.patch"
	"${FILESDIR}/${P}-respect-ldflags.patch"
	"${FILESDIR}/${P}-test-failure-hack.patch"
	"${FILESDIR}/${P}-blas.patch"
	"${FILESDIR}/${P}-wformat-security.patch"
)
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
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	tc-export CC CXX
	if use mpi; then
		export CC=mpicc
		export CXX=mpicxx
	fi

	econf \
		$(use_enable threads) \
		$(use_enable mpi parallel) \
		$(use_enable static-libs static)

	sed \
		-e "s:^CFLAGS =.*$:CFLAGS=${CFLAGS}:" \
		-e "s:^FFLAGS =.*$:FFLAGS=${FFLAGS:- -O2}:" \
		-e "s:^CXXFLAGS =.*$:CXXFLAGS=${CXXFLAGS}:" \
		-i lib/LocalMakefile || die
}

src_test() {
	cd src/bin/mpqc/validate || die

	# we'll only run the small test set, since the
	# medium and large ones take >10h and >24h on my
	# 1.8Ghz P4M
	emake -j1 check1
}

src_install() {
	emake installroot="${D}" install install_devel install_inc

	# make extended docs
	if use doc; then
		cd doc || die
		emake all
		doman man/man1/* man/man3/*
		dodoc -r html/
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
