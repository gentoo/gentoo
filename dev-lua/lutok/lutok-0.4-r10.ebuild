# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
LUA_COMPAT=( lua5-{1..4} )

inherit lua-single

DESCRIPTION="Lightweight C++ API library for Lua"
HOMEPAGE="https://github.com/jmmv/lutok"
SRC_URI="https://github.com/jmmv/lutok/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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

src_configure() {
	lua_setup
	local myconf=(
		--enable-shared
		--disable-static
		LUA_CFLAGS="$(lua_get_CFLAGS)"
		LUA_LIBS="$(lua_get_LIBS)"
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	rm -rf "${ED}"/usr/tests || die
	find "${ED}" -name '*.la' -type f -delete || die
}
