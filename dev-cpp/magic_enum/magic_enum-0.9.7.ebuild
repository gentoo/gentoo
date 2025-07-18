# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# As of 0.8.2, it has meson, but only for subproject use(?)
# Doesn't install anything. In 0.9.7, the situation looks better, but
# need to test with reverse dependencies.
inherit cmake

DESCRIPTION="Static reflection for enums in header-only C++"
HOMEPAGE="https://github.com/Neargye/magic_enum"
SRC_URI="https://github.com/Neargye/magic_enum/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.7-werror.patch
)

src_configure() {
	local mycmakeargs=(
		-DMAGIC_ENUM_OPT_BUILD_EXAMPLES=$(usex examples)
		-DMAGIC_ENUM_OPT_BUILD_TESTS=$(usex test)
		-DMAGIC_ENUM_OPT_INSTALL=ON
	)

	cmake_src_configure
}
