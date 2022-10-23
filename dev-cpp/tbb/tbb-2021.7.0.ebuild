# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://www.threadingbuildingblocks.org"
SRC_URI="https://github.com/oneapi-src/oneTBB/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/oneTBB-${PV}"

LICENSE="Apache-2.0"
# https://github.com/oneapi-src/oneTBB/blob/master/CMakeLists.txt#L53
# libtbb<SONAME>-libtbbmalloc<SONAME>-libtbbbind<SONAME>
SLOT="0/12.5-2.5-3.5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="!kernel_Darwin? ( sys-apps/hwloc:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# bug #872287
	filter-flags -D_GLIBCXX_ASSERTIONS
	append-cppflags -U_GLIBCXX_ASSERTIONS

	local mycmakeargs=(
		-DTBB_TEST=$(usex test)
		-DTBB_ENABLE_IPO=OFF
		-DTBB_STRICT=OFF
	)

	cmake-multilib_src_configure
}
