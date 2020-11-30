# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_p/-}"

inherit toolchain-funcs

DESCRIPTION="A simple and complete ini parser for Lua"
HOMEPAGE="https://github.com/bartbes/inifile/"
SRC_URI="https://github.com/bartbes/inifile/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="luajit"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:= )
"

BDEPEND="virtual/pkgconfig"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	doins inifile.lua
}
