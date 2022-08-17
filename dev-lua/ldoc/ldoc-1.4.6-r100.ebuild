# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 luajit )

inherit lua-single

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="https://stevedonovan.github.io/ldoc/"
SRC_URI="https://github.com/lunarmodules/LDoc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 ~riscv x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="$(lua_gen_cond_dep '
	dev-lua/penlight[${LUA_USEDEP}]
')"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.6-mkdir.patch"
	"${FILESDIR}/${PN}-1.4.6-slotted_lua.patch"
)

S="${WORKDIR}/LDoc-${PV}"
RESTRICT="test"

src_install() {
	emake DESTDIR="${ED}" LUA_BINDIR="${EPREFIX}/usr/bin" LUA_SHAREDIR="$(lua_get_lmod_dir)" install
}
