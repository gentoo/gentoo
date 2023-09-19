# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake cuda

MY_COMMIT="c8df37f6ac73250998b90c397458469902d6d9b9"

DESCRIPTION="Struct of arrays library with object oriented interface for C++"
HOMEPAGE="
	http://www.libgeodecomp.org/libflatarray.html
	https://github.com/STEllAR-GROUP/libflatarray"
SRC_URI="https://github.com/STEllAR-GROUP/libflatarray/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cuda examples test"
RESTRICT="!test? ( test )"

DEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )"

S="${WORKDIR}/libflatarray-${MY_COMMIT}"

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

src_test() {
	cmake_build check
}
