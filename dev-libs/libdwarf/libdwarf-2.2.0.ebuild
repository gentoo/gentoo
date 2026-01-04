# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library intended to simplify reading (and writing) applications using DWARF"
HOMEPAGE="
	https://www.prevanders.net/dwarf.html
	https://github.com/davea42/libdwarf-code
"
SRC_URI="https://www.prevanders.net/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1 BSD"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test dwarfexample dwarfgen"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/zstd:=
	virtual/zlib:=
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS NEWS README.md )

PATCHES=( "${FILESDIR}/${PN}-0.9.2-fix-include-patch.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED=ON
		-DBUILD_DWARFGEN=$(usex dwarfgen)
		-DBUILD_DWARFEXAMPLE=$(usex dwarfexample)
		-DDO_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_install(){
	cmake_src_install

	dodoc ChangeLog* doc/*.pdf
}
