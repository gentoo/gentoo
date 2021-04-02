# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ninja doesn't like "-lcblas" so using make.
CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{7..9} )
inherit cmake python-any-r1

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

LICENSE="LGPL-2.1+"

# Based off the soname, e.g. /usr/lib64/libflint.so -> libflint.so.15
SLOT="0/15"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="doc ntl test"

RESTRICT="!test? ( test )"

BDEPEND="doc? (
	dev-python/sphinx
	app-text/texlive-core
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	dev-tex/latexmk
	)
	${PYTHON_DEPS}"
DEPEND="dev-libs/gmp:=
	dev-libs/mpfr:=
	ntl? ( dev-libs/ntl:= )
	virtual/cblas"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_NTL="$(usex ntl)"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_DOCS="$(usex doc)"
		-DCBLAS_INCLUDE_DIRS="${EPREFIX}/usr/include"
		-DCBLAS_LIBRARIES="-lcblas"
	)

	cmake_src_configure

	if use doc ; then
		HTML_DOCS="${BUILD_DIR}/html/*"
		DOCS=(
			"${S}"/README
			"${S}"/AUTHORS
			"${S}"/NEWS
			"${BUILD_DIR}"/latex/Flint.pdf
		)
	fi
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		cmake_build html
		cmake_build pdf
	fi
}
