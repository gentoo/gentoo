# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib

DESCRIPTION="A client-side library that implements a custom algorithm for extracting fingerprints"
HOMEPAGE="http://acoustid.org/chromaprint"
SRC_URI="https://bitbucket.org/acoustid/${PN}/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE="libav test tools"

# note: use ffmpeg or libav instead of fftw because it's recommended and required for tools
RDEPEND="
	libav? ( >=media-video/libav-11:0=[${MULTILIB_USEDEP}] )
	!libav? ( >=media-video/ffmpeg-2.6:0=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest[${MULTILIB_USEDEP}]
		dev-libs/boost[${MULTILIB_USEDEP}]
	)"

DOCS="NEWS.txt README.md"

PATCHES=( "${FILESDIR}"/${PN}-1.1-gtest.patch )

multilib_src_configure() {
	local mycmakeargs=(
		"-DBUILD_EXAMPLES=$(multilib_native_usex tools ON OFF)"
		"-DBUILD_TESTS=$(usex test ON OFF)"
		-DWITH_AVFFT=ON
		)
	cmake-utils_src_configure
}

multilib_src_test() {
	emake check
}
