# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Fork of the zlib data compression library"
HOMEPAGE="https://github.com/zlib-ng/zlib-ng"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="compat test"

RESTRICT="!test? ( test )"

src_prepare() {
	cmake_src_prepare

	# https://github.com/zlib-ng/zlib-ng/issues/881
	sed "/LIB_INSTALL_DIR/s@/lib\"@/$(get_libdir)\"@" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DZLIB_COMPAT="$(usex compat)"
		-DZLIB_ENABLE_TESTS="$(usex test)"
		# Unaligned access is controversial and undefined behaviour
		# Let's keep it off for now
		# https://github.com/gentoo/gentoo/pull/17167
		-DWITH_UNALIGNED="OFF"
	)
	cmake_src_configure
}
