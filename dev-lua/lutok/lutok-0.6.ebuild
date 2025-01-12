# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua5-{3..4} )

inherit autotools lua-single

DESCRIPTION="Lightweight C++ API library for Lua"
HOMEPAGE="https://github.com/freebsd/lutok"
SRC_URI="https://github.com/freebsd/lutok/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

pkg_setup() {
	:
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	lua_setup
	local myconf=(
		--enable-shared
		--disable-static
		$(use_enable test atf)
		LUA_VERSION="${ELUA#lua}"
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	rm -rf "${ED}"/usr/tests || die
	find "${ED}" -name '*.la' -type f -delete || die
}
