# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
GTEST_VERSION="1.10.0"
inherit cmake-multilib

DESCRIPTION="Library implementing a custom algorithm for extracting audio fingerprints"
HOMEPAGE="https://acoustid.org/chromaprint"
SRC_URI="https://github.com/acoustid/${PN}/releases/download/v${PV}/${P}.tar.gz
	test? ( https://github.com/google/googletest/archive/release-${GTEST_VERSION}.tar.gz -> gtest-${GTEST_VERSION}.tar.gz )
"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test tools"
RESTRICT="!test? ( test )"

# note: use ffmpeg instead of fftw because it's recommended and required for tools
RDEPEND=">=media-video/ffmpeg-2.6:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"

DOCS=( NEWS.txt README.md )

S="${WORKDIR}/${PN}-v${PV}"

multilib_src_configure() {
	export GTEST_ROOT="${WORKDIR}/googletest-release-${GTEST_VERSION}/googletest/"
	local mycmakeargs=(
		-DBUILD_TOOLS=$(multilib_native_usex tools ON OFF)
		-DBUILD_TESTS=$(usex test ON OFF)
		-DFFT_LIB=avfft
		-DAUDIO_PROCESSOR_LIB="swresample"
	)
	cmake_src_configure
}

multilib_src_test() {
	emake check
}
