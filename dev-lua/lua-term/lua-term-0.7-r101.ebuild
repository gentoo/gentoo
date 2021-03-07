# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PV="0.07"

inherit lua toolchain-funcs

DESCRIPTION="Terminal operations for Lua"
HOMEPAGE="https://github.com/hoelzro/lua-term"
SRC_URI="https://github.com/hoelzro/lua-term/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~sparc x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-O3//g' -i Makefile

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CFLAGS=${CFLAGS} ${LDFLAGS} $(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}" all

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		LUA_LIBDIR="${ED}/$(lua_get_cmod_dir)/term"
		LUA_SHARE="${ED}/$(lua_get_lmod_dir)/term"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install
}
