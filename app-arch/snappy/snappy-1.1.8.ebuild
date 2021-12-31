# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-multilib

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://github.com/google/snappy"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV%%.*}"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ~ppc64 s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

# all test dependencies are optional:
# - gflags-2.2 is supposedly needed for command-line option parsing
# but it's a huge hack and does not work,
# - gtest probably gives nicer output,
# - compression libraries are used for benchmarks which we do not run.
DEPEND="test? ( dev-cpp/gtest )"

# AUTHORS is useless, ChangeLog is stale
DOCS=( format_description.txt framing_format.txt NEWS README.md )

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/snappy-1.1.7-0001-cmake-Add-missing-linking-to-GTEST_LIBRARIES.patch
	)

	# command-line option parsing does not work at all, so just force
	# it off
	sed -i -e '/run_microbenchmarks/s:true:false:' snappy-test.cc || die

	cmake-utils_src_prepare
}

multilib_src_configure() {
	# TODO: would be nice to make unittest build conditional
	# but it is not a priority right now
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON

		# use gtest for tests only
		-DCMAKE_DISABLE_FIND_PACKAGE_GTest=$(usex '!test')
		# gflags does not work anyway
		-DCMAKE_DISABLE_FIND_PACKAGE_Gflags=ON

		# we do not want to run benchmarks, and those are only used
		# for benchmarks
		-DHAVE_LIBZ=NO
		-DHAVE_LIBLZO2=NO
	)
	cmake-utils_src_configure
}

multilib_src_test() {
	# run tests directly to get verbose output
	cd "${S}" || die
	"${BUILD_DIR}"/snappy_unittest || die
}
