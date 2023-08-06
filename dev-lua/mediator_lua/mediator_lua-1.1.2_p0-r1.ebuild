# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PV="${PV/_p/-}"

inherit lua

DESCRIPTION="Mediator pattern implementation for pub-sub management"
HOMEPAGE="http://olivinelabs.com/mediator_lua/"
SRC_URI="https://github.com/Olivine-Labs/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		dev-lua/lua_cliargs[${LUA_USEDEP}]
		${RDEPEND}
	)
"

lua_src_test() {
	busted --lua=${ELUA} || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins src/mediator.lua
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
