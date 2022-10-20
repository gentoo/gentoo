# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="CLI and library for quickly generating prime numbers"
HOMEPAGE="https://github.com/kimwalisch/primesieve"
SRC_URI="https://github.com/kimwalisch/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0/10"  # subslot is first component of libprimesieve.so version
KEYWORDS="amd64"
IUSE="doc +executable test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen app-text/texlive media-gfx/graphviz )"
DEPEND=""
RDEPEND=""

DOCS=(
	ChangeLog
	README.md
	doc/ALGORITHMS.md
	doc/CPP_API.md
	doc/C_API.md
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC="$(usex doc)"
		-DBUILD_PRIMESIEVE="$(usex executable)"
		-DBUILD_STATIC_LIBS="OFF"
		-DBUILD_TESTS="$(usex test)"
	)

	if use doc; then
		DOCS+=(
			"${BUILD_DIR}/doc/html"
			"${BUILD_DIR}/doc/latex/refman.pdf"
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}
