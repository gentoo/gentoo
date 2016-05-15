# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils fortran-2 multilib toolchain-funcs

DESCRIPTION="Suite for ab initio quantum chemistry computing various molecular properties"
HOMEPAGE="http://www.psicode.org/"
SRC_URI="mirror://sourceforge/psicode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs test"

RDEPEND="
	!sci-visualization/extrema
	virtual/blas
	virtual/lapack
	>=sci-libs/libint-1.1.4:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/byacc
	test? ( dev-lang/perl )"

S="${WORKDIR}/${PN}${PV:0:1}"

PATCHES=(
	"${FILESDIR}"/${PV}-dont-build-libint.patch
	"${FILESDIR}"/use-external-libint.patch
	"${FILESDIR}"/${PV}-gcc-4.3.patch
	"${FILESDIR}"/${PV}-destdir.patch
	"${FILESDIR}"/${P}-parallel-make.patch
	"${FILESDIR}"/${PV}-man_paths.patch
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PV}-parallel_fix.patch
	"${FILESDIR}"/${PV}-fortify.patch
	"${FILESDIR}"/${P}-format-security.patch
	)

src_prepare() {
	autotools-utils_src_prepare
	# Broken test
	sed \
		-e 's:scf-mvd-opt ::g' \
		-e 's:scf-mvd-opt-puream ::g' \
		-i tests/Makefile.in || die

	sed \
		-e "/LIBPATTERNS/d" \
		-i src/{bin,util,samples}/MakeVars.in || die
	eautoreconf
}

src_configure() {
	# This variable gets set sometimes to /usr/lib/src and breaks stuff
	unset CLIBS

	local myeconfargs=(
		--with-opt="${CXXFLAGS}"
		--datadir="${EPREFIX}"/usr/share/${PN}
		--with-blas="$($(tc-getPKG_CONFIG) blas --libs)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile \
		SCRATCH="${WORKDIR}/libint" \
		DODEPEND="no" \
		YACC=byacc
}

src_test() {
	emake EXECDIR="${S}"/bin TESTFLAGS="" -j1 tests
}

src_install() {
	autotools-utils_src_install DODEPEND="no"
	if ! use static-libs; then
		rm -f "${ED}"/usr/$(get_libdir)/*.a || die
	fi
}
