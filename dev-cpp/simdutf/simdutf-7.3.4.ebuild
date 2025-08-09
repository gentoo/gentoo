# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR=""

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake docs python-any-r1

DESCRIPTION="Unicode validation and transcoding at billions of characters per second"
HOMEPAGE="https://simdutf.github.io/simdutf/"

SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"

SLOT="0/25"

KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libiconv
	"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	dev-libs/icu
	doc? (
		app-text/doxygen
	)
"

src_compile() {
	default
	cmake_src_compile
	use doc && docs_compile
}

src_install() {
	default
	cmake_src_install
	use doc && einstalldocs
}
