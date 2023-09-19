# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Utility to convert hex or dec to binary format"
HOMEPAGE="https://bitbucket.org/PascalRD/i2bits/"
SRC_URI="http://unixdev.ru/src/${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	sed -e "s/^set(CMAKE_C_FLAGS.*/set(CMAKE_C_FLAGS \"${CFLAGS}\")/" \
		-e "1s/^/project(${PN})\n/" \
		-i CMakeLists.txt || die "can't patch CMakeLists.txt"

	cmake_src_prepare
}
