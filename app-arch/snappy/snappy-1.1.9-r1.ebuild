# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://github.com/google/snappy"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV%%.*}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

DOCS=( format_description.txt framing_format.txt NEWS README.md )

PATCHES=(
	"${FILESDIR}/${P}_gcc_inline.patch"
	"${FILESDIR}/${P}_external_gtest.patch"
	"${FILESDIR}/${P}-clang-werror.patch"
	"${FILESDIR}/${P}_remove-no-rtti.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DSNAPPY_BUILD_TESTS=$(usex test)
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
