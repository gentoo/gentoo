# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A collection of LPEG patterns"
HOMEPAGE="https://github.com/daurnimator/lpeg_patterns"
SRC_URI="https://github.com/daurnimator/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	dev-lua/lpeg[${LUA_USEDEP}]
"
RDEPEND="${DEPEND}"

lua_enable_tests busted

lua_src_install() {
	insinto $(lua_get_lmod_dir)/${MY_PN}/
	doins ${MY_PN}/*.lua
}

src_install() {
	lua_foreach_impl lua_src_install
	einstalldocs
}
