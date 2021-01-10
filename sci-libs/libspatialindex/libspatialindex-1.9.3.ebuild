# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P="spatialindex-src-${PV}"

DESCRIPTION="C++ implementation of R*-tree, an MVR-tree and a TPR-tree with C API"
HOMEPAGE="https://libspatialindex.org/
	https://github.com/libspatialindex/libspatialindex"
SRC_URI="https://github.com/libspatialindex/${PN}/releases/download/${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0/6"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

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
