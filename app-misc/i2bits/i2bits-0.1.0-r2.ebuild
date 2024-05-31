# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="4c613505b2cb"
DESCRIPTION="Utility to convert hex or dec to binary format"
HOMEPAGE="https://bitbucket.org/PascalRD/i2bits/"
SRC_URI="https://bitbucket.org/PascalRD/i2bits/get/${COMMIT}.tar.gz -> ${P}-bb.tar.gz"
S="${WORKDIR}/PascalRD-${PN}-${COMMIT}"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	sed -e "s/^set(CMAKE_C_FLAGS.*/set(CMAKE_C_FLAGS \"${CFLAGS}\")/" \
		-e "1s/^/project(${PN})\n/" \
		-i CMakeLists.txt || die "can't patch CMakeLists.txt"

	cmake_src_prepare
}
