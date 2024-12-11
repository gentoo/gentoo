# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# maintainer recommends to "live at head" so we ship snapshots
COMMIT="155c6b9e76e462e1d47ea528ca87f366adccdea3"

DESCRIPTION="A date and time library based on the C++11/14/17 <chrono> header"
HOMEPAGE="https://github.com/HowardHinnant/date"
SRC_URI="https://github.com/HowardHinnant/date/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="only-c-locale test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( llvm-core/clang )" # tests call clang++

PATCHES=(
	"$FILESDIR"/${PN}-3.0.1_p20240913_remove-failing-tests.patch
)

src_prepare() {
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
	cd "${SRC_DIR}"test/ || die
	./testit || die
}
