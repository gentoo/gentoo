# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GTEST_VERSION="1.10.0"
GTEST_DIR_VERSION="1.10.x"
inherit cmake-multilib

DESCRIPTION="Library implementing a custom algorithm for extracting audio fingerprints"
HOMEPAGE="https://acoustid.org/chromaprint"
SRC_URI="https://github.com/acoustid/${PN}/releases/download/v${PV}/${P}.tar.gz
	test? ( https://github.com/google/googletest/archive/v$(ver_cut 1-2 ${GTEST_VERSION}).x.tar.gz -> gtest-${GTEST_VERSION}.tar.gz )
"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test tools"
RESTRICT="!test? ( test )"

# Default to fftw to avoid awkward circular dependency w/ ffmpeg
# See bug #833821 for an example
RDEPEND="tools? ( media-video/ffmpeg:=[${MULTILIB_USEDEP}] )
	!tools? ( sci-libs/fftw:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"

DOCS=( NEWS.txt README.md )

multilib_src_configure() {
	export GTEST_ROOT="${WORKDIR}/googletest-${GTEST_DIR_VERSION}/googletest/"

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)

		-DBUILD_TOOLS=$(multilib_native_usex tools)
		-DFFT_LIB=$(usex tools 'avfft' 'fftw3')
		#-DAUDIO_PROCESSOR_LIB="swresample"
		$(multilib_native_usex tools '-DAUDIO_PROCESSOR_LIB=swresample' '')
		# Automagicallyish looks for ffmpeg, but there's no point
		# even doing the check unless we're building with tools
		# (=> without fftw3, and with ffmpeg).
		-DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=$(multilib_native_usex !tools)
	)

	cmake_src_configure
}

multilib_src_test() {
	cd tests && (./all_tests || die "Tests failed")
}
