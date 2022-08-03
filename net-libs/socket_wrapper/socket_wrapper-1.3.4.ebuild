# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="A library passing all socket communications through unix sockets"
HOMEPAGE="https://cwrap.org/socket_wrapper.html"
SRC_URI="https://ftp.samba.org/pub/cwrap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( >=dev-util/cmocka-1.1.0 )"

src_configure() {
	local mycmakeargs=(
		-DUNIT_TESTING=$(usex test ON OFF)
	)
	cmake-multilib_src_configure
}
