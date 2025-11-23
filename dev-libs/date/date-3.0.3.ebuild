# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Date and time library based on the C++11/14/17 <chrono> header"
HOMEPAGE="https://github.com/HowardHinnant/date"
SRC_URI="https://github.com/HowardHinnant/date/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64"
IUSE="only-c-locale test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${PN}-3.0.3_remove-failing-tests.patch )

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
	cd test/ || die
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" ./testit || die
}
