# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A date and time library based on the C++11/14/17 <chrono> header"
HOMEPAGE="https://github.com/HowardHinnant/date"

SRC_URI="https://github.com/HowardHinnant/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~arm64"

LICENSE="MIT"
SLOT="0/3.0.0"
IUSE="only-c-locale test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-c-locale-export.patch
	"${FILESDIR}"/${P}-version.patch
)

src_prepare() {
	# The test cases are implicitly generated with CMake code, that parses
	# the file names for ".cpp" and ".fail.cpp". Renaming the source files
	# disables the test.

	# This test case fails due to a stdlibc++ bug.
	# Upstream bug: https://github.com/HowardHinnant/date/issues/388
	mv "test/date_test/parse.pass.cpp" "test/date_test/parse.disabled" || ewarn "Can not deactivate test case, test failure expected"

	# This test case fails only when the CMAKE_BUILD_TYPE=Gentoo.
	# The behaviour seems very strange, but does not appear with a
	# "valid" build type.
	# Upstream bug: https://github.com/HowardHinnant/date/issues/604
	mv "test/clock_cast_test/local_t.pass.cpp" "test/clock_cast_test/local_t.disabled" || ewarn "Can not deactivate test case, test failure expected"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TZ_LIB=ON
		-DUSE_SYSTEM_TZ_DB=ON
		-DENABLE_DATE_TESTING=$(usex test)
		-DCOMPILE_WITH_C_LOCALE=$(usex only-c-locale)
	)
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	ninja testit
}
