# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils

DESCRIPTION="A client-side library that implements a custom algorithm for extracting fingerprints"
HOMEPAGE="http://acoustid.org/chromaprint"
SRC_URI="mirror://github/lalinsky/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test tools"

# note: use ffmpeg instead of fftw because it's recommended and required for tools
RDEPEND=">=virtual/ffmpeg-0.10
	tools? ( >=media-libs/taglib-1.6 )"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-libs/boost
	)
	tools? ( dev-libs/boost )"

DOCS="NEWS.txt README.txt"

PATCHES=( "${FILESDIR}"/${P}-boost.patch
		  "${FILESDIR}"/${P}-ffmpeg.patch
		  "${FILESDIR}"/${P}-libav9.patch )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build tools EXAMPLES)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_build tools)
		-DWITH_AVFFT=ON
		)

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	emake check
}

src_install() {
	cmake-utils_src_install
	use tools && dobin "${CMAKE_BUILD_DIR}"/tools/fpcollect
}
