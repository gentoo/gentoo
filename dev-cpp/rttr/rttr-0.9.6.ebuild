# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Run Time Type Reflection - library adding reflection to C++"
HOMEPAGE="https://www.rttr.org/"
SRC_URI="https://github.com/rttrorg/${PN}/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-permission.patch"
	"${FILESDIR}/${P}-tests.patch"
	"${FILESDIR}/${P}-werror.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=off #broken
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/bin/unit_tests || die
}
