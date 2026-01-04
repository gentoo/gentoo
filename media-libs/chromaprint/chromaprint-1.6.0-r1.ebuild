# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Library implementing a custom algorithm for extracting audio fingerprints"
HOMEPAGE="https://acoustid.org/chromaprint"
SRC_URI="https://github.com/acoustid/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ~ppc ppc64 ~riscv ~sparc ~x86"
IUSE="test tools"
RESTRICT="!test? ( test )"

# - Default to fftw to avoid awkward circular dependency w/ ffmpeg
# See bug #833821 for an example
RDEPEND="
	tools? ( >=media-video/ffmpeg-5:=[${MULTILIB_USEDEP}] )
	!tools? ( sci-libs/fftw:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

DOCS=( NEWS.txt README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-unbundle_gtest.patch
)

src_prepare() {
	# remove gtest (unbundled) and fftkiss (unused)
	rm -r src/3rdparty || die
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DBUILD_TOOLS=$(multilib_native_usex tools)
		-DFFT_LIB=$(usex tools 'avtx' 'fftw3')
		# Automagicallyish looks for ffmpeg, but there's no point
		# even doing the check unless we're building with tools
		# (=> without fftw3, and with ffmpeg).
		-DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=$(multilib_native_usex !tools)
	)

	cmake_src_configure
}
