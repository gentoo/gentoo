# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	cc@1.0.73
"

RUST_MIN_VERSION="1.77.4"

inherit cargo cmake

DESCRIPTION="Marrying Rust and CMake - Easy Rust and C/C++ Integration!"
HOMEPAGE="https://github.com/corrosion-rs/corrosion"
SRC_URI="
	https://github.com/corrosion-rs/corrosion/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( ${CARGO_CRATE_URIS} )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-util/cbindgen )
	>=dev-build/cmake-3.22
"

PATCHES=(
	"${FILESDIR}/corrosion-0.5.2_fix_tests.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCORROSION_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
