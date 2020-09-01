# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Lua bindings to zlib"
HOMEPAGE="https://github.com/brimworks/lua-zlib"
SRC_URI="https://github.com/brimworks/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="dev-lang/lua:0
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local lua_version="$(pkg-config --modversion lua)"
	local mycmakeargs=(
		-DINSTALL_CMOD="$(pkg-config --variable INSTALL_CMOD lua)"
		-DUSE_LUA_VERSION="$(ver_cut 1-2 ${lua_version})"
	)
	cmake_src_configure
}
