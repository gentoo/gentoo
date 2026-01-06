# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
inherit edo lua-single

DESCRIPTION="LuaDoc-compatible documentation generation system"
HOMEPAGE="https://stevedonovan.github.io/ldoc/"
SRC_URI="https://github.com/lunarmodules/LDoc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/penlight[${LUA_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-slotted_lua.patch
)

src_test() {
	# reproduce run-tests.lua with exit on failure
	local t
	for t in tests tests/example tests/md-test; do
		pushd "${t}" >/dev/null || die
		edo ${LUA} "${S}"/ldoc.lua --dir cdocs --testing .
		edo ${LUA} "${S}"/ldoc.lua -testing .
		edob -m "verifying ${t}" diff -r doc cdocs
		popd >/dev/null || die
	done
}

src_install() {
	emake DESTDIR="${ED}" LUA_BINDIR="${EPREFIX}/usr/bin" LUA_SHAREDIR="$(lua_get_lmod_dir)" install
}
