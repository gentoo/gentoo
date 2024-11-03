# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Suite for ab initio quantum chemistry computing various molecular properties"
HOMEPAGE="http://www.psicode.org/"
SRC_URI="https://downloads.sourceforge.net/psicode/${P}.tar.gz"
S="${WORKDIR}/${PN}${PV:0:1}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
# psi3/psiclean segfault because tests were never run before
RESTRICT="test"

RDEPEND="
	!sci-visualization/extrema
	virtual/blas
	virtual/lapack
	>=sci-libs/libint-1.1.4:1"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/byacc
	virtual/pkgconfig
	test? ( dev-lang/perl )"

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
	"${FILESDIR}"/${P}-perl-File-Temp.patch
	"${FILESDIR}"/${P}-C99.patch
)

src_prepare() {
	default

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

	econf \
		--with-opt="${CXXFLAGS}" \
		--datadir="${EPREFIX}"/usr/share/${PN} \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
}

src_compile() {
	emake \
		SCRATCH="${WORKDIR}/libint" \
		DODEPEND="no" \
		YACC=byacc
}

src_test() {
	emake EXECDIR="${S}"/bin TESTFLAGS="" -j1 tests
}

src_install() {
	emake DESTDIR="${D}" DODEPEND="no" install
	einstalldocs

	# convenience libraries
	rm "${ED}"/usr/$(get_libdir)/*.a || die
}
