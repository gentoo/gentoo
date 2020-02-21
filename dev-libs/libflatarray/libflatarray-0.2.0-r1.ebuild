# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake cuda

DESCRIPTION="Struct of arrays library with object oriented interface for C++"
HOMEPAGE="
	http://www.libgeodecomp.org/libflatarray.html
	https://github.com/STEllAR-GROUP/libflatarray"
SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cuda examples"
RESTRICT="test"

DEPEND=">=dev-libs/boost-1.48
	cuda? ( dev-util/nvidia-cuda-toolkit )"

src_prepare() {
	cmake_src_prepare
	use cuda && cuda_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CUDA=$(usex cuda)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}
		dodoc -r examples/
		dodoc -r "${WORKDIR}"/${P}_build/examples/
		find "${ED}"/usr/share/doc/${PF} -iname "*cmake*" -exec rm -r {} + || die
	fi
}
