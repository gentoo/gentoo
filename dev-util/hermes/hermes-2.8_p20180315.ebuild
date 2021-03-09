# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
inherit lua-single

DESCRIPTION="Lua based testing manager"
HOMEPAGE="https://github.com/TACC/Hermes"
if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TACC/Hermes"
else
	COMMIT="b99622087233178368cff6cf38ec72fa01dfd8a6"
	SRC_URI="https://github.com/TACC/Hermes/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/Hermes-${COMMIT}
	KEYWORDS="~amd64 ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/luafilesystem[${LUA_USEDEP}]
		dev-lua/luaposix[${LUA_USEDEP}]
	')
"
DEPEND="test? ( ${RDEPEND} )"

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
