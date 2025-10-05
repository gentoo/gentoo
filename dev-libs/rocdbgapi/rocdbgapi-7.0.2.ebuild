# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AMD Debugger API"
HOMEPAGE="https://github.com/ROCm/ROCdbgapi"
SRC_URI="https://github.com/ROCm/ROCdbgapi/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ROCdbgapi-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="doc"

BDEPEND="
	doc? (
		app-text/doxygen[dot]
		virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-plaingeneric
	)
"
RDEPEND="
	dev-libs/rocm-comgr:${SLOT}
"
DEPEND="
	${RDEPEND}
	dev-libs/rocr-runtime:${SLOT}
"

src_prepare() {
	sed -e "s/-Werror//" \
		-e "s:\${CMAKE_INSTALL_DATADIR}/html/amd-dbgapi:\${CMAKE_INSTALL_DOCDIR}/html:" \
		-e "s/COMPONENT asan/COMPONENT asan EXCLUDE_FROM_ALL/" \
		-i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_REQUIRE_FIND_PACKAGE_Doxygen=$(usex doc)
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !doc)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}
