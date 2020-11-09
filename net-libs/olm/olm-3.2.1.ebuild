# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Implementation of the olm and megolm cryptographic ratchets"
HOMEPAGE="https://gitlab.matrix.org/matrix-org/olm"
SRC_URI="https://gitlab.matrix.org/matrix-org/olm/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	local mycmakeargs=(
		"-DOLM_TESTS=OFF"
		"-DBUILD_SHARED_LIBS=ON"
	)
	cmake_src_configure
}
