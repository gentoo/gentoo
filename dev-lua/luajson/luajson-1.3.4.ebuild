# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="JSON Parser/Constructor for Lua"
HOMEPAGE="https://www.eharning.us/wiki/luajson/"
SRC_URI="https://github.com/harningt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="dev-lua/lpeg[${LUA_USEDEP}]"

# Require lunitx, which is not in the tree yet
RESTRICT="test"

DOCS=( README.md docs/ReleaseNotes-${PV}.txt docs/LuaJSON.txt )

# nothing to compile
src_compile() { :; }

lua_src_install() {
	emake DESTDIR="${ED}" INSTALL_LMOD="$(lua_get_lmod_dir)" install
}

src_install() {
	lua_foreach_impl lua_src_install
	einstalldocs
}
