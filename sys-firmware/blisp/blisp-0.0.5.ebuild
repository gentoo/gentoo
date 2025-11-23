# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Bouffalo Labs in-system-programming tool and library"
HOMEPAGE="https://github.com/pine64/blisp"
SRC_URI="https://github.com/pine64/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="+tools"

RDEPEND="dev-libs/argtable3
	dev-libs/libserialport"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare

	# Be extra sure we're not using vendored deps
	rm -r vendor || die
}

src_configure() {

	local mycmakeargs=(
		-DBLISP_USE_SYSTEM_LIBRARIES=ON
		-DBLISP_BUILD_CLI=$(usex tools)
		-DCOMPILE_TESTS=OFF  # requires unpackaged googletest
	)
	cmake_src_configure
}
