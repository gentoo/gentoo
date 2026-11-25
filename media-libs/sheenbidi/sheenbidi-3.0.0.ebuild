# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Use cmake instead of meson to get the cmake configuration file for libsfml.
# Also meson builds tests unconditionally
inherit cmake

DESCRIPTION="A sophisticated implementation of Unicode Bidirectional Algorithm"
HOMEPAGE="https://github.com/Tehreer/SheenBidi"
SRC_URI="
	https://github.com/Tehreer/SheenBidi/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/SheenBidi-${PV}"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DSB_CONFIG_UNITY=OFF
		#-DBUILD_GENERATOR= use flag?
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
