# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simple, portable, and self-contained stacktrace library for C++11 and newer"
HOMEPAGE="https://github.com/jeremy-rifkin/cpptrace"
SRC_URI="https://github.com/jeremy-rifkin/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/zstd:=
	dev-libs/libdwarf:=
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_prepare() {
	default

	# Unused CMake files with compatibility issues.
	rm -v test/*/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCPPTRACE_BUILD_TESTING=$(usex test)
		-DCPPTRACE_USE_EXTERNAL_GTEST=yes
		-DCPPTRACE_USE_EXTERNAL_LIBDWARF=yes
		-DCPPTRACE_USE_EXTERNAL_ZSTD=yes
	)
	cmake_src_configure
}
