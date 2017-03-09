# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

# The below is the upstream version number. The -x suffix should be kept
# in sync with the _px suffix in the ebuild version.
MY_PV="2.0.rc11-0"

DESCRIPTION="Elegant Lua unit testing"
HOMEPAGE="http://olivinelabs.com/busted/"
SRC_URI="https://github.com/Olivine-Labs/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:="
DEPEND="${COMMON_DEPEND}
virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	~dev-lua/lua_cliargs-2.5_p5
	>=dev-lua/luafilesystem-1.5.0
	>=dev-lua/dkjson-2.1.0
	>=dev-lua/say-1.3
	>=dev-lua/luassert-1.7.8
	>=dev-lua/lua-term-0.1_p1
	>=dev-lua/penlight-1.3.2
	>=dev-lua/mediator_lua-1.1.1_p0
	>=dev-lua/luasocket-2.0.1
"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
dobin bin/busted
insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"/${PN}
doins -r busted/*
dodoc *.md
}
