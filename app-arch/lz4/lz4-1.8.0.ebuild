# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lz4/lz4.git"
	EGIT_BRANCH=dev
else
	SRC_URI="https://github.com/Cyan4973/lz4/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/lz4/lz4"

LICENSE="BSD-2 GPL-2"
# https://abi-laboratory.pro/tracker/timeline/lz4/
# 1.7.5->1.8.0 has some minor changes; the only really incompatible
# would be removing 'const' from LZ4F_freeDecompressionContext() arg
# however, it is extremely unlikely that this 'const' would actually
# be relied on
SLOT="0/r131"
IUSE="static-libs"

CMAKE_USE_DIR=${S}/contrib/cmake_unofficial

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)

	cmake-utils_src_configure
}
