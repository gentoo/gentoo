# Copyright 1999-2024 Gentoo Authors
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
	dev-libs/rocr-runtime:${SLOT}
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "s/-Werror//" \
		-e "s/if(DOXYGEN_FOUND)/if(WITH_DOCS AND DOXYGEN_FOUND)/" \
		-e "s:\${CMAKE_INSTALL_DATADIR}/html/amd-dbgapi:\${CMAKE_INSTALL_DOCDIR}/html:" \
		-i CMakeLists.txt || die

	# Clang 19 detects error
	# https://github.com/ROCm/ROCdbgapi/issues/12
	sed -e "s/->n_next/->m_next/g" -i src/utils.h || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DOCS=$(usex doc ON OFF)
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install

	# remove unneeded copy
	rm -r "${ED}/usr/share/doc/${PF}-asan" || die
}
