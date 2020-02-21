# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils cuda

MYPV=${PV/_/-}

DESCRIPTION="Library to manipulate tensors on the GPU"
HOMEPAGE="http://deeplearning.net/software/libgpuarray/"
SRC_URI="https://github.com/Theano/${PN}/archive/v${MYPV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc opencl static-libs test"
RESTRICT="!test? ( test )"

# cuda/opencl loaded dynamically at runtime, no compile time dep
RDEPEND="
	cuda? (	amd64? ( >=dev-util/nvidia-cuda-toolkit-7 ) )
	opencl? (
	   virtual/opencl
	   || ( sci-libs/clblast sci-libs/clblas )
	)
"
DEPEND="
	doc? ( app-doc/doxygen )
	test? ( ${RDEPEND}
	   dev-libs/check
	   virtual/pkgconfig
	)
"
S="${WORKDIR}/${PN}-${MYPV}"

src_prepare() {
	sed -e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/g' \
		-i src/CMakeLists.txt || die
	use cuda && cuda_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=()
	cmake-utils_src_configure
	use doc && emake -C doc doxy
}

src_test() {
	local dev=cuda
	use opencl && dev=opencl
	DEVICE=${dev} cmake-utils_src_test
	# if !cuda or !opencl: no testing because tests fail
}

src_install() {
	use doc && HTML_DOCS=( doc/_doxybuild/html/. )
	cmake-utils_src_install
	use static-libs || rm "${ED}/usr/$(get_libdir)/libgpuarray-static.a"
}
