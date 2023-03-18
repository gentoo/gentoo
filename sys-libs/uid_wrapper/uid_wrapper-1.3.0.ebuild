# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Wrapper to fake privilege separation"
HOMEPAGE="https://cwrap.org/uid_wrapper.html"
SRC_URI="https://www.samba.org/ftp/pub/cwrap/${P}.tar.gz
	https://ftp.samba.org/pub/cwrap/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-util/cmocka )"

src_configure() {
	local mycmakeargs=(
		-DUNIT_TESTING=$(usex test)
	)

	cmake-multilib_src_configure
}
