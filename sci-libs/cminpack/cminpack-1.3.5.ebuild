# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C implementation of the MINPACK nonlinear optimization library"
HOMEPAGE="http://devernay.free.fr/hacks/cminpack/"
SRC_URI="https://github.com/devernay/cminpack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="minpack"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${P}-underlinking.patch )

src_configure() {
	local mycmakeargs=(
		-DCMINPACK_LIB_INSTALL_DIR=$(get_libdir)
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_EXAMPLES=$(usex test)
	)
	cmake-utils_src_configure
	use test && export LD_LIBRARY_PATH="${BUILD_DIR}:${LD_LIBRARY_PATH}"
}

src_install() {
	cmake-utils_src_install
	dodoc readme*
	use doc && dodoc -r doc/*
}
