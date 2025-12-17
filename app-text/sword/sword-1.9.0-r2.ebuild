# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for Bible reading software"
HOMEPAGE="https://www.crosswire.org/sword/"
SRC_URI="https://www.crosswire.org/ftpmirror/pub/${PN}/source/v${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="clucene curl icu test utils"
REQUIRED_USE="test? ( curl icu utils )"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	virtual/zlib:=
	curl? ( net-misc/curl )
	icu? ( dev-libs/icu:= )
	clucene? ( dev-cpp/clucene:1 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.0-cflags.patch
	"${FILESDIR}"/${PN}-1.9.0-cmake4.patch
)

DOCS=( AUTHORS CODINGSTYLE ChangeLog README examples/ samples/ )

src_configure() {
	local mycmakeargs=(
		# skip unnecessary tests, bug #954771
		-DCMAKE_DISABLE_FIND_PACKAGE_cppcheck="ON"
		-DCMAKE_SKIP_RPATH="ON"
		# default is shared and static
		-DLIBSWORD_LIBRARY_TYPE="Shared"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DSYSCONF_INSTALL_DIR="${EPREFIX}/etc"
		-DSWORD_BUILD_TESTS=$(usex test)
		-DSWORD_BUILD_UTILS=$(usev !utils No)
		-DSWORD_NO_CLUCENE=$(usev !clucene Yes)
		-DWITH_CLUCENE=$(usex clucene)
		-DSWORD_NO_CURL=$(usev !curl Yes)
		-DWITH_CURL=$(usex curl)
		-DSWORD_NO_ICU=$(usev !icu Yes)
		-DWITH_ICU=$(usex icu)
		-DWITH_ZLIB=1
	)

	cmake_src_configure
}

src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}"
	cmake_src_test
}
