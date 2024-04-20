# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Wrapper for the user, group and hosts NSS API"
HOMEPAGE="https://cwrap.org/nss_wrapper.html"
SRC_URI="https://ftp.samba.org/pub/cwrap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

# sys-libs/uid_wrapper is used to "better test initgroups()" optionally
BDEPEND="
	test? (
		dev-util/cmocka
		sys-libs/uid_wrapper
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-cmocka-cmake.patch
)

src_configure() {
	local mycmakeargs=(
		-DUNIT_TESTING=$(usex test)
	)

	cmake-multilib_src_configure
}
