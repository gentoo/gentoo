# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils toolchain-funcs versionator cuda

DESCRIPTION="An Open-Source subdivision surface library"
HOMEPAGE="http://graphics.pixar.com/opensubdiv/"

MY_PV="$(replace_all_version_separators '_')"


SRC_URI="https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
IUSE="cuda doc examples opencl opengl openmp ptex tbb test tutorials"

# OpenCL does not work with Open Source drivers.
RDEPEND="media-libs/glew:=
	media-libs/glfw:=
	opencl? ( x11-drivers/ati-drivers:* )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	ptex? ( media-libs/ptex:* )
	opengl? ( virtual/opengl )"

DEPEND="${RDEPEND}
	tbb? ( dev-cpp/tbb:= )
	doc? ( dev-python/docutils app-doc/doxygen:* )"

KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-skip-osd-regression.patch
	"${FILESDIR}"/${P}-clGLVertexBuffer.patch
	)

S="${WORKDIR}"/OpenSubdiv-${MY_PV}

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp ; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
}

src_prepare() {
	use cuda && cuda_src_prepare

	cmake-utils_src_prepare
}


#-DNO_LIB=1        // disable the opensubdiv libs build (caveat emptor)
#-DNO_EXAMPLES=1   // disable examples build
#-DNO_TUTORIALS=1  // disable tutorials build
#-DNO_REGRESSION=1 // disable regression tests build
#-DNO_PTEX=1       // disable PTex support
#-DNO_DOC=1        // disable documentation build
#-DNO_OMP=1        // disable OpenMP
#-DNO_TBB=1        // disable TBB
#-DNO_CUDA=1       // disable CUDA
#-DNO_OPENCL=1     // disable OpenCL
#-DNO_OPENGL=1     // disable OpenGL
#-DNO_CLEW=1       // disable CLEW wrapper library
src_configure() {
	local mycmakeargs=(
		-DNO_CLEW=1
		-DNO_DOC=$(usex !doc)
		-DNO_TBB=$(usex !tbb)
		-DNO_PTEX=$(usex !ptex)
		-DNO_OMP=$(usex !openmp)
		-DNO_OPENCL=$(usex !opencl)
		-DNO_OPENGL=$(usex !opengl)
		-DNO_CUDA=$(usex !cuda)
		-DNO_REGRESSION=$(usex !test)
		-DNO_EXAMPLES=$(usex !examples)
		-DNO_TUTORIALS=$(usex !tutorials)
		-DGLEW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DGLFW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
	)

	use cuda && mycmakeargs+=(
		-DCUDA_NVCC_FLAGS="${NVCCFLAGS},-arsch"
	)

	cmake-utils_src_configure
}
