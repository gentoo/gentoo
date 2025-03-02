# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Production grade, very easy to use, procfs parsing library in C++"
HOMEPAGE="https://github.com/dtrugman/pfs"
SRC_URI="https://github.com/dtrugman/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${P}-Werror.patch )

src_prepare() {
	rm test/test_proc_stat.cpp | dir
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Dpfs_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/out/unittest || die
}
