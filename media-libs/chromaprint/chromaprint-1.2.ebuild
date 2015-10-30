# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="A client-side library that implements a custom algorithm for extracting fingerprints"
HOMEPAGE="http://acoustid.org/chromaprint"
SRC_URI="https://bitbucket.org/acoustid/${PN}/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 x86 ~amd64-fbsd"
IUSE="libav test tools"

# note: use ffmpeg or libav instead of fftw because it's recommended and required for tools
RDEPEND="
	libav? ( media-video/libav:0= )
	!libav? ( >=media-video/ffmpeg-2.6:0= )
"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-libs/boost
	)"

DOCS="NEWS.txt README.md"

PATCHES=( "${FILESDIR}"/${PN}-1.1-gtest.patch "${FILESDIR}"/${P}-ffmpeg29.patch )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build tools EXAMPLES)
		$(cmake-utils_use_build test TESTS)
		-DWITH_AVFFT=ON
		)
	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	emake check
}

src_install() {
	cmake-utils_src_install
}
