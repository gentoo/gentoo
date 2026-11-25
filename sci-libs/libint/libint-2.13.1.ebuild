# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic fortran-2 multiprocessing

DESCRIPTION="Matrix elements (integrals) evaluation over Cartesian Gaussian functions"
HOMEPAGE="https://github.com/evaleev/libint"
SRC_URI="https://github.com/evaleev/libint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs doc"

DEPEND="
	dev-libs/boost
	dev-libs/gmp[cxx(+)]
	doc? (
		app-text/texlive[science]
		dev-texlive/texlive-latex
		dev-tex/latex2html
		dev-texlive/texlive-latexextra
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
)

src_configure() {
	# bug #862894
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DLIBINT2_REQUIRE_CXX_API=OFF
		-DLIBINT2_REQUIRE_CXX_API_COMPILED=OFF
		-DLIBINT2_ENABLE_ERI=2
		-DLIBINT2_ENABLE_ERI3=2
		-DLIBINT2_ENABLE_ERI2=2
		-DLIBINT2_ERI_MAX_AM=7\;5\;4
		-DLIBINT2_ERI_OPT_AM=3
		-DLIBINT2_ERI3_MAX_AM=7
		-DLIBINT2_ERI2_MAX_AM=7
		-DLIBINT2_G12_MAX_AM=5
		-DLIBINT2_G12_OPT_AM=3
		-DLIBINT2_G12DKH_MAX_AM=5
		-DLIBINT2_G12DKH_OPT_AM=3
		-DLIBINT2_CONTRACTED_INTS=ON
		-DBUILD_SHARED_LIBS=ON
		-DLIBINT2_BUILD_SHARED_AND_STATIC_LIBS=$(usex static-libs)
	)
	cmake_src_configure
}

src_compile() {
	local -x CMAKE_BUILD_PARALLEL_LEVEL="$(get_makeopts_jobs)"
	local srcdir="${BUILD_DIR}"/src/lib/libint/library-prefix/src
	mkdir -p "${srcdir}"/library-build/include/libint2/boost \
		|| die
	cmake_src_compile
	if use doc; then
		cd "${srcdir}"/library/doc || die
		pdflatex progman.tex || die
		mv progman.pdf "${S}"/doc/progman/ || die
		latex2html progman.tex || die
		mv progman/*.{html,png,css,svg} "${S}"/doc/progman/ || die
	fi
}

src_install() {
	cmake_src_install
	dodir /usr/$(get_libdir)
	mv "${ED}/${BUILD_DIR}"/src/lib/libint/library-install-stage/lib*/libint2.so "${ED}"/usr/$(get_libdir)/ || die
	rm -r "${ED}"/var || die

	if use doc; then
		DOCS=( doc/progman/progman.pdf )
		HTML_DOCS=( doc/progman/*.{html,png,css,svg} )
		einstalldocs
	fi
}
