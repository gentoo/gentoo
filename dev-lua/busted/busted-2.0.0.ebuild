# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Elegant Lua unit testing"
HOMEPAGE="http://olivinelabs.com/busted/"
SRC_URI="https://github.com/Olivine-Labs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/lua-5.1:=
	>=dev-lua/lua_cliargs-3.0
	>=dev-lua/luafilesystem-1.5.0
	>=dev-lua/luasystem-0.2.0
	>=dev-lua/dkjson-2.1.0
	>=dev-lua/say-1.3
	>=dev-lua/luassert-1.7.8
	>=dev-lua/lua-term-0.1_p1
	>=dev-lua/penlight-1.3.2
	>=dev-lua/mediator_lua-1.1.1_p0
"
BDEPEND="
	virtual/pkgconfig
	test? (
		${RDEPEND}
		>=dev-lua/busted-2.0.0
	)
"
DEPEND="${RDEPEND}"

src_test() {
	busted ./spec || die
}

src_install() {
	dobin bin/busted
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"/${PN}
	doins -r busted/*
	dodoc *.md
}
