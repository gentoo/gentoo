# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: add src_test, check MPI support, unrespected LDFLAGS QA

inherit flag-o-matic fortran-2 toolchain-funcs

MY_P="ccx_${PV/_/}"

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program (Solver)"
HOMEPAGE="https://www.calculix.de"

SRC_URI="
	https://www.dhondt.de/${MY_P}.src.tar.bz2
	doc? (
		https://www.dhondt.de/${MY_P}.ps.tar.bz2
	)
	examples? (
		https://www.dhondt.de/${MY_P}.test.tar.bz2
	)
"
S="${WORKDIR}/CalculiX/${MY_P}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples openmp threads"
RESTRICT="test" # TODO

RDEPEND="
	>=sci-libs/arpack-3.1.3
	>=sci-libs/spooles-2.2[threads=]
	virtual/blas
	virtual/lapack
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/ghostscript-gpl
	)
"

PATCHES=(
	"${FILESDIR}/${P}-fix-makefile-to-respect-system-settings.patch"
	"${FILESDIR}/${P}-return-NULL.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
}

src_configure() {
	# many -Wlto-type-mismatch
	filter-lto

	# Technically we currently only need this when arpack is not used.
	# Keeping things this way in case we change pkgconfig for arpack
	export LAPACK=$($(tc-getPKG_CONFIG) --libs lapack)

	# allow compilation with gcc-10
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=957064
	if test-flag-FC -fallow-argument-mismatch; then
		append-fflags -fallow-argument-mismatch
	fi

	append-cflags "-I${ESYSROOT}/usr/include/spooles -DSPOOLES"
	if use threads; then
		append-cflags "-DUSE_MT"
	fi

	if use openmp; then
		append-fflags "-fopenmp"
		append-cflags "-fopenmp"
	fi

	export ARPACKLIB=$($(tc-getPKG_CONFIG) --libs arpack)
	append-cflags "-DARPACK"

	export CC="$(tc-getCC)"
	export FC="$(tc-getFC)"
}

src_install () {
	dobin "${MY_P}"
	dosym -r "/usr/bin/${MY_P}" "/usr/bin/ccx"

	dodoc BUGS LOGBOOK README.INSTALL TODO
	if use doc; then
		pushd "${S}/../doc" >/dev/null || die
		ps2pdf ${MY_P}.ps ${MY_P}.pdf || die "ps2pdf failed"
		dodoc ${MY_P}.pdf
		popd >/dev/null || die
	fi

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r "${S}"/../test/*
	fi
}
