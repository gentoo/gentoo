# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C implementation of the MINPACK nonlinear optimization library"
HOMEPAGE="http://devernay.free.fr/hacks/cminpack/"
SRC_URI="https://github.com/devernay/cminpack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="minpack"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RESTRICT="!test? ( test )"

DOCS=( README.md readme.txt )

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_configure() {
	local mycmakeargs=(
		-DUSE_BLAS=OFF # TODO: pick it up if you want to
		-DCMINPACK_LIB_INSTALL_DIR=$(get_libdir)
		-DBUILD_EXAMPLES=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	use doc && local HTML_DOCS=( docs/. )
	cmake_src_install
}
