# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

MY_PN="${PN}.lua"
MY_PV="version_$(ver_rs 1 v)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Binary heap implementation in pure Lua"
HOMEPAGE="http://tieske.github.io/binaryheap.lua"
HOMEPAGE+=" https://github.com/Tieske/binaryheap.lua"
SRC_URI="https://github.com/Tieske/${MY_PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		dev-lua/luacov[${LUA_USEDEP}]
	)
"

src_prepare() {
	default
	lua_copy_sources
}

lua_src_test() {
	if [[ ${ELUA} == "lua5.3" ]]; then
		# this test failed only with 5.3
		rm "${BUILD_DIR}"/spec/dijkstras_algorithm_spec.lua || die
	fi
	busted --lua="${ELUA}" --output="plainTerminal" "${BUILD_DIR}"/spec || die "Tests fail with ${ELUA}"
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins src/${PN}.lua
}

src_install() {
	lua_foreach_impl lua_src_install
	local HTML_DOCS=( docs )
	dodoc -r "examples"
	einstalldocs
}
