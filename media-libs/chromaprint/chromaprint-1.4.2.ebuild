# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-multilib

GTEST_VERSION="1.8.0"

DESCRIPTION="A client-side library that implements a custom algorithm for extracting fingerprints"
HOMEPAGE="https://acoustid.org/chromaprint"
SRC_URI="https://bitbucket.org/acoustid/${PN}/downloads/${P}.tar.gz
	test? (	https://github.com/google/googletest/archive/release-${GTEST_VERSION}.tar.gz -> gtest-${GTEST_VERSION}.tar.gz )
"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd"
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

multilib_src_configure() {
	export GTEST_ROOT="${WORKDIR}/googletest-release-${GTEST_VERSION}/googletest/"
	local mycmakeargs=(
		"-DBUILD_TOOLS=$(multilib_native_usex tools ON OFF)"
		"-DBUILD_TESTS=$(usex test ON OFF)"
		-DFFT_LIB=avfft
		-DAUDIO_PROCESSOR_LIB=$(usex libav avresample swresample)
		)
	cmake-utils_src_configure
}

multilib_src_test() {
	emake check
}
