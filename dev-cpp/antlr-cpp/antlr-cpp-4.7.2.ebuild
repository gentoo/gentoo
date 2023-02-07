# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="The ANTLR 4 C++ Runtime"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://www.antlr.org/download/antlr4-cpp-runtime-${PV}-source.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm ~ppc x86"

BDEPEND="app-arch/unzip"

src_prepare() {
	sed -i -e "s#DESTINATION lib#DESTINATION $(get_libdir)#" \
		"${S}"/runtime/CMakeLists.txt || die "failed sed"

	sed -i -e "s#share/doc/libantlr4#share/doc/${PF}#g" \
		"${S}"/CMakeLists.txt || die "failed sed"

	cmake_src_prepare
}
