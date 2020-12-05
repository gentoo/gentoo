# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
inherit lua-single

DESCRIPTION="Lua based testing manager"
HOMEPAGE="https://github.com/TACC/Hermes"
SRC_URI="https://github.com/TACC/Hermes/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/Hermes-${PV}

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/luaposix[${LUA_USEDEP}]
	')
"

PATCHES=( "${FILESDIR}"/${PN}-2.8-lua-shebang.patch )

src_compile() {
	sed -e "s|@LUA@|${LUA}|g" \
	    -i lib/tool.lua \
	    -i bin/lua_cmd || die
}

src_test() {
	local -x PATH="bin:${PATH}"
	tm -vvv || die
	testcleanup || die
}

src_install() {
	dodir /opt/hermes
	cp -r "${S}"/. "${ED}"/opt/hermes/ || die

	doenvd "${FILESDIR}"/99hermes
}
