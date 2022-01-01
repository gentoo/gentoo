# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit cmake lua

DESCRIPTION="Simple streaming interface to zlib for Lua"
HOMEPAGE="https://github.com/brimworks/lua-zlib"
SRC_URI="https://github.com/brimworks/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

lua_src_configure() {
	local mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_cmod_dir)"
		-DUSE_LUA_VERSION="$(lua_get_version)"
	)

	if [[ ${ELUA} == luajit ]]; then
		mycmakeargs+=( -DUSE_LUAJIT="ON" )
	fi

	cmake_src_configure
}

src_configure() {
	lua_foreach_impl lua_src_configure
}

src_compile() {
	lua_foreach_impl cmake_src_compile
}

src_install() {
	lua_foreach_impl cmake_src_install
}
