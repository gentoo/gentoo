# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils toolchain-funcs versionator

DESCRIPTION="An Open-Source subdivision surface library"
HOMEPAGE="http://graphics.pixar.com/opensubdiv/"

MY_PV="$(replace_all_version_separators '_')"

SRC_URI="https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
IUSE="cuda doc examples opencl openmp ptex tbb tutorials"

RDEPEND="media-libs/glew:=
	media-libs/glfw:=
	cuda? ( dev-util/nvidia-cuda-toolkit:* )
	ptex? ( media-libs/ptex )"

DEPEND="${RDEPEND}
	tbb? ( dev-cpp/tbb )
	doc? ( dev-python/docutils app-doc/doxygen )"

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/OpenSubdiv-${MY_PV}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake-utils_src_prepare

	sed -e 's|"${OSD_SONAME}"|${OSD_SONAME}|' \
	    -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DNO_MAYA=1
		-DNO_CLEW=1
		-DNO_DOC=$(usex !doc)
		-DNO_TBB=$(usex !tbb)
		-DNO_PTEX=$(usex !ptex)
		-DNO_OMP=$(usex !openmp)
		-DNO_OPENCL=$(usex !opencl)
		-DNO_CUDA=$(usex !cuda)
		-DNO_REGRESSION=1 # The don't work with certain settings
		-DNO_EXAMPLES=$(usex !examples)
		-DNO_TUTORIALS=$(usex !tutorials)
		-DGLEW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DGLFW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}
