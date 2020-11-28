# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )
MY_PV="0.07"
MY_PV_SO="1.0.1"

inherit lua toolchain-funcs

DESCRIPTION="Terminal operations for Lua"
HOMEPAGE="https://github.com/hoelzro/lua-term"
SRC_URI="https://github.com/hoelzro/lua-term/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-O3//g' -i Makefile
}

lua_src_compile() {
	# Clean project to compile it for every lua slot
	emake clean

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CFLAGS=${CFLAGS} ${LDFLAGS} $(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}" all

	# Copy module to match the choosen LUA implementation
	cp "core.so.${MY_PV_SO}" "core-${ELUA}.so.${MY_PV_SO}" || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	# Use correct module for the choosen LUA implementation
	cp "core-${ELUA}.so.${MY_PV_SO}" "core.so.${MY_PV_SO}" || die

	local myemakeargs=(
		LUA_LIBDIR="${ED}/$(lua_get_cmod_dir)/term"
		LUA_SHARE="${ED}/$(lua_get_lmod_dir)/term"
	)

	emake "${myemakeargs[@]}" install
}

src_install() {
	lua_foreach_impl lua_src_install
}
