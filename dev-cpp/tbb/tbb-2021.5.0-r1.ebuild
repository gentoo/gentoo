# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://www.threadingbuildingblocks.org"
SRC_URI="https://github.com/oneapi-src/oneTBB/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/oneTBB-${PV}"

LICENSE="Apache-2.0"
# https://github.com/oneapi-src/oneTBB/blob/master/CMakeLists.txt#L53
# libtbb<SONAME>-libtbbmalloc<SONAME>-libtbbbind<SONAME>
SLOT="0/12.5-2.5-3.5"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-apps/hwloc:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# should be in.. 2022?
	"${FILESDIR}"/${PN}-2021.4.0-lto.patch
	"${FILESDIR}"/${PN}-2021.5.0-musl-deepbind.patch
	# bug 827883
	"${FILESDIR}"/${PN}-2021.4.0-missing-TBB_machine_fetchadd4.patch
	# need to verify this is in master
	"${FILESDIR}"/${PN}-2021.5.0-musl-mallinfo.patch
	# musl again, should be in.. 2022?
	"${FILESDIR}"/${PN}-2021.5.0-musl-setcontext.patch
	# should be in.. 2022?
	"${FILESDIR}"/${PN}-2021.5.0-x86-mwaitpkg.patch

	"${FILESDIR}"/${PN}-2021.5.0-flags-stripping.patch
)

src_configure() {
	local mycmakeargs=(
		-DTBB_TEST=$(usex test)
		-DTBB_ENABLE_IPO=OFF
		-DTBB_STRICT=OFF
	)

	cmake-multilib_src_configure
}
