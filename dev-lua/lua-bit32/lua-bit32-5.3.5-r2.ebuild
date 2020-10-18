# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

# Weird upstream version descisions...
# Result tarball may be reused for future lua-compat53 package
LUA_COMPAT_PN="lua-compat-5.3"
LUA_COMPAT_PV="0.10"

DESCRIPTION="Backported Lua bit manipulation library"
HOMEPAGE="https://github.com/keplerproject/lua-compat-5.3"
SRC_URI="https://github.com/keplerproject/${LUA_COMPAT_PN}/archive/v${LUA_COMPAT_PV}.tar.gz -> lua-compat53-${LUA_COMPAT_PV}.tar.gz"

S="${WORKDIR}/${LUA_COMPAT_PN}-${LUA_COMPAT_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="dev-lang/lua:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	# TODO maybe sometime there will be luarocks eclass...
	compile="$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fPIC -I/usr/include -c lbitlib.c -o lbitlib.o -DLUA_COMPAT_BITLIB -Ic-api"
	einfo "${compile}"
	eval "${compile}" || die

	link="$(tc-getCC) -shared ${LDFLAGS} -o bit32.so lbitlib.o"
	einfo "${link}"
	eval "${link}" || die
}

src_test() {
	LUA_CPATH=./?.so lua tests/test-bit32.lua || die
}

src_install() {
	exeinto $($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)
	doexe bit32.so
	dodoc README.md
}
