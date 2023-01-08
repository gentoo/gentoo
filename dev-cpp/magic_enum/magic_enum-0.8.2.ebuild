# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# As of 0.8.2, it has meson, but only for subproject use(?)
# Doesn't install anything.
inherit cmake

DESCRIPTION="Static reflection for enums in header-only C++"
HOMEPAGE="https://github.com/Neargye/magic_enum"
SRC_URI="https://github.com/Neargye/magic_enum/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
# Tests fail to compile
RESTRICT="!test? ( test ) test"

src_configure() {
	local mycmakeargs=(
		-DMAGIC_ENUM_OPT_BUILD_TESTS=$(usex test)
		-DMAGIC_ENUM_OPT_INSTALL=ON
	)

	cmake_src_configure
}
