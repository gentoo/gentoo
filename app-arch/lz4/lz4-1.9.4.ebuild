# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/lz4/lz4"
SRC_URI="https://github.com/lz4/lz4/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 GPL-2"
# https://abi-laboratory.pro/tracker/timeline/lz4/
SLOT="0/r132"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

CMAKE_USE_DIR=${S}/build/cmake

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)

	cmake_src_configure
}
