# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )
inherit cmake-utils python-any-r1

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/14"
KEYWORDS="amd64 ~arm ~arm64 ppc ~x86"
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
	ntl? ( dev-libs/ntl:= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.0-multilib-strict.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_NTL="$(usex ntl)"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_DOCS="$(usex doc)"
	)

	cmake-utils_src_configure

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
	cmake-utils_src_compile

	if use doc ; then
		cmake-utils_src_make html
		cmake-utils_src_make pdf
	fi
}
