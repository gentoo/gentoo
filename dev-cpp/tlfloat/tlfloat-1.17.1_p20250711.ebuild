# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Upstream don't seem to tag releases. Check TLFLOAT_VERSION_{MAJOR,MINOR,PATCH}
# in CMakeLists.txt. Reverse dependencies may need quite new versions so
# we want PV to be accurate.
CommitId=38f525b838b05dd5c266d34b16cb554cf1fe37c5

DESCRIPTION="C++ template library for floating point operations"
HOMEPAGE="https://shibatch.github.io/tlfloat-doxygen/"
SRC_URI="https://github.com/shibatch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${P}-fPIC.patch )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
