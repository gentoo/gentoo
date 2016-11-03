# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils cuda

SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"
KEYWORDS="~amd64 ~ppc ~x86"

DESCRIPTION="Struct of arrays library with object oriented interface for C++"
HOMEPAGE="http://www.libgeodecomp.org/libflatarray.html"

SLOT="0"
LICENSE="Boost-1.0"
IUSE="cuda doc"

DEPEND="
	doc? ( app-doc/doxygen )
	cuda? ( dev-util/nvidia-cuda-toolkit )"

src_prepare() {
	cmake-utils_src_prepare
	use cuda && cuda_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CUDA=$(usex cuda)
		-DWITH_SILO=false
	)
	cmake-utils_src_configure
}
