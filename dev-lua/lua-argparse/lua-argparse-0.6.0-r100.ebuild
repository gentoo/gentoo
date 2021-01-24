# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Command line argument parser for the Lua Programming Language"
HOMEPAGE="https://github.com/mpeterv/argparse"
SRC_URI="https://github.com/mpeterv/${PN/lua-/}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN//lua-/}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		${RDEPEND}
	)
"

src_compile() {
	if use doc; then
		sphinx-build docsrc html || die
		rm -rf "${S}"/html/{.doctrees,_sources} || die
	fi
}

lua_src_test() {
	busted  --exclude-tags="unsafe" --lua=${ELUA} || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/argparse.lua
}

src_install() {
	default

	use doc && local -a HTML_DOCS=( "html/." )
	einstalldocs

	lua_foreach_impl lua_src_install
}
