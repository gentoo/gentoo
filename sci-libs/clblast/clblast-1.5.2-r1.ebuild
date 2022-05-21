# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MYPN="CLBlast"

DESCRIPTION="Tuned OpenCL BLAS"
HOMEPAGE="https://github.com/CNugteren/CLBlast"
SRC_URI="https://github.com/CNugteren/${MYPN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MYPN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
# Cuda is still beta, default to opencl
IUSE="client cuda examples +opencl test"
REQUIRED_USE="
	^^ ( cuda opencl )
	test? ( client )
"
# Tests require write access to /dev/dri/renderD...
RESTRICT="test"
# RESTRICT="!test? ( test )"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	client? ( virtual/cblas )
	opencl? ( virtual/opencl )
"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/level2_xtrsv.patch
	  "${FILESDIR}"/level3_xtrsv.patch )

src_prepare() {
	# no forced optimisation, libdir
	sed -e 's/-O3//g' \
		-e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/g' \
		-i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
		-DSAMPLES="$(usex examples)"
		-DCLIENTS="$(usex client)"
		-DNETLIB="$(usex client)"
		-DTESTS="$(usex test)"
		-DOPENCL="$(usex opencl)"
		-DCUDA="$(usex cuda)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc README.md ROADMAP.md CONTRIBUTING.md CHANGELOG
	dodoc -r doc
}
