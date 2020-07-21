# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="spatialindex-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="General framework for developing spatial indices"
HOMEPAGE="https://libspatialindex.org/
	https://github.com/libspatialindex/libspatialindex"
SRC_URI="https://github.com/libspatialindex/${PN}/releases/download/${PV}/${MY_P}.tar.bz2"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0/6"
IUSE="test"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.3-respect-compiler-flags.patch
)

src_configure() {
	local mycmakeargs=(
		-DSIDX_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
