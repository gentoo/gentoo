# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast and lightweight x86/x86-64 disassembler and code generation library"
HOMEPAGE="https://zydis.re"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zyantific/zydis.git"
else
	SRC_URI="https://github.com/zyantific/zydis/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc man test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/zycore-c
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
	man? ( app-text/ronn-ng )
"

src_configure() {
	local mycmakeargs=(
		-DZYDIS_BUILD_SHARED_LIB=yes
		-DZYDIS_BUILD_EXAMPLES=no
		-DZYDIS_BUILD_TOOLS=yes
		-DZYDIS_BUILD_MAN=$(usex man)
		-DZYDIS_BUILD_DOXYGEN=$(usex doc)
		-DZYDIS_BUILD_TESTS=$(usex test)
		-DZYAN_SYSTEM_ZYCORE=yes
	)

	cmake_src_configure
}
