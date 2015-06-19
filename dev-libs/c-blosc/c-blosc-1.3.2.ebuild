# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/c-blosc/c-blosc-1.3.2.ebuild,v 1.7 2015/04/02 07:21:10 jlec Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Blocking, shuffling and lossless compression library"
HOMEPAGE="http://www.blosc.org/"
SRC_URI="https://github.com/Blosc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="hdf5 +lz4 +snappy static-libs test zlib"

RDEPEND="
	hdf5? ( sci-libs/hdf5 )
	lz4? ( >=app-arch/lz4-0_p120 )
	snappy? ( app-arch/snappy )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-shared-libs.patch )
DOCS="RE* AN*"

src_configure() {
	local mycmakeargs=(
		-DBUILD_BENCHMARKS=OFF
		-DPREFER_EXTERNAL_COMPLIBS=ON
		$(cmake-utils_use hdf5 BUILD_HDF5_FILTER)
		$(cmake-utils_use !lz4 DEACTIVATE_LZ4)
		$(cmake-utils_use !snappy DEACTIVATE_SNAPPY)
		$(cmake-utils_use static-libs BUILD_STATIC)
		$(cmake-utils_use test BUILD_TESTS)
		$(cmake-utils_use !zlib DEACTIVATE_ZLIB)
	)
	cmake-utils_src_configure
}
