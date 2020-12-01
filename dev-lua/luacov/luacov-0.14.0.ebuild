# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple coverage analyzer for Lua scripts"
HOMEPAGE="https://github.com/keplerproject/luacov"
SRC_URI="https://github.com/keplerproject/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="luajit test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted
		${RDEPEND}
	)
"

HTML_DOCS=( "doc/." )

src_test() {
	busted --lua="$(usex luajit 'luajit' 'lua')" || die
}

src_install() {
	dobin src/bin/luacov

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	doins src/luacov.lua
	doins -r src/luacov

	einstalldocs
}
