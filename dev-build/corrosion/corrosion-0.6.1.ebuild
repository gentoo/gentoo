# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	bitflags@1.3.2
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
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-util/cbindgen )
	>=dev-build/cmake-3.22
"

CMAKE_SKIP_TESTS=(
	# requires extensive rust-src cargo packages
	custom_target_build
	custom_target_run_test-exe
	custom_target_run_rust-bin
	install_lib_build
	install_lib_run_main-static
	install_lib_run_main-shared
)

src_configure() {
	local mycmakeargs=(
		-DCORROSION_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
