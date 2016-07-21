# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils multilib toolchain-funcs flag-o-matic

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://embree.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick ispc jpeg openexr png static-libs"

RDEPEND="dev-cpp/tbb
	media-libs/freeglut
	imagemagick? (
	   || ( media-gfx/imagemagick[cxx] media-gfx/graphicsmagick[cxx] )
	)
	ispc? ( dev-lang/ispc )
	jpeg? ( virtual/jpeg:0 )
	openexr? ( media-libs/openexr )
	png? ( media-libs/libpng:0 )"
DEPEND="${RDEPEND}"

src_prepare() {
	filter-flags "-march=*"
	sed -e "s:PREFIX}/lib:PREFIX}/$(get_libdir):g" \
		-e "s:lib/cmake:$(get_libdir)/cmake:g" \
		-e "/LICENSE.txt/d" \
		-e "/DIRECTORY tutorials/d" \
		-i common/cmake/package.cmake || die
	sed -e "s/gcc/$(tc-getCC)/" \
		-e "s/g++/$(tc-getCXX)/" \
		-e "s/-fPIC/${CXXFLAGS} &/" \
		-i common/cmake/gcc.cmake || die
	sed -e "/COMPONENT lib/ s/\(DESTINATION \)lib/\1$(get_libdir)/g" \
		-i kernels/xeon/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_TUTORIALS=OFF
		$(cmake-utils_use_enable static-libs STATIC_LIB)
		$(cmake-utils_use_enable ispc ISPC_SUPPORT)
		$(cmake-utils_use_use jpeg LIBJPEG)
		$(cmake-utils_use_use png LIBPNG)
		$(cmake-utils_use_use imagemagick IMAGE_MAGICK)
		$(cmake-utils_use_use openexr OPENEXR)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so
}
