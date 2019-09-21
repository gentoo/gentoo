# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs eapi7-ver

MY_PV="$(ver_rs "1-3" '_')"
DESCRIPTION="An Open-Source subdivision surface library"
HOMEPAGE="http://graphics.pixar.com/opensubdiv/"
SRC_URI="https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="cuda doc opencl openmp ptex tbb"

RDEPEND="media-libs/glew:=
	media-libs/glfw:=
	cuda? ( dev-util/nvidia-cuda-toolkit:* )
	opencl? ( virtual/opencl )
	ptex? ( media-libs/ptex )"

DEPEND="${RDEPEND}
	doc? (
		dev-python/docutils
		app-doc/doxygen
	)
	tbb? ( dev-cpp/tbb )"

S="${WORKDIR}/OpenSubdiv-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${PN}-3.3.0-fix-quotes.patch"
	"${FILESDIR}/${PN}-3.3.0-use-gnuinstalldirs.patch"
	"${FILESDIR}/${PN}-3.3.0-add-CUDA9-compatibility.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DNO_CLEW=1
		-DNO_DOC=$(usex !doc)
		-DNO_TBB=$(usex !tbb)
		-DNO_PTEX=$(usex !ptex)
		-DNO_OMP=$(usex !openmp)
		-DNO_OPENCL=$(usex !opencl)
		-DNO_CUDA=$(usex !cuda)
		-DNO_REGRESSION=1 # They don't work with certain settings
		-DNO_EXAMPLES=1 # Not needed.
		-DNO_TUTORIALS=1 # They install illegally. Need to find a better solution.
		-DGLEW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DGLFW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}
