# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://github.com/google/snappy"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV%%.*}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

DOCS=( format_description.txt framing_format.txt NEWS README.md )

PATCHES=(
	"${FILESDIR}/${PN}-1.1.9_external_gtest.patch"
	"${FILESDIR}/${PN}-1.1.9-clang-werror.patch"
	"${FILESDIR}/${PN}-1.1.9_remove-no-rtti.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14 # Latest gtest needs -std=c++14 or newer
		-DSNAPPY_BUILD_TESTS=$(usex test)
		-DSNAPPY_REQUIRE_AVX=$(usex cpu_flags_x86_avx)
		-DSNAPPY_REQUIRE_AVX2=$(usex cpu_flags_x86_avx2)
		-DSNAPPY_BUILD_BENCHMARKS=OFF
		# Options below are related to benchmarking, that we disable.
		-DHAVE_LIBZ=NO
		-DHAVE_LIBLZO2=NO
		-DHAVE_LIBLZ4=NO
	)
	cmake_src_configure
}

multilib_src_test() {
	# run tests directly to get verbose output
	cd "${S}" || die
	"${BUILD_DIR}"/snappy_unittest || die
}
