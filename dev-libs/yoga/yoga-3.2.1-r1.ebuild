# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a

DESCRIPTION="Cross-platform layout engine"
HOMEPAGE="https://github.com/facebook/yoga"
SRC_URI="https://github.com/facebook/yoga/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/"${P}-add-tests-option.patch"
	"${FILESDIR}"/"${P}-fix-tests.patch"
)

src_configure() {
	lto-guarantee-fat
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DBUILD_FUZZ_TESTS=OFF #Requires the compiler to be Clang
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/tests/yogatests || die
}

src_install() {
	cmake_src_install
	strip-lto-bytecode
}
