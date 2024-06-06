# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3,4} )
LUA_REQ_USE="deprecated"

inherit cmake lua-single

DESCRIPTION="Live Syncing (Mirror) Daemon"
HOMEPAGE="https://github.com/lsyncd/lsyncd"
SRC_URI="https://github.com/lsyncd/lsyncd/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}"
RDEPEND="${LUA_DEPS}
	net-misc/rsync"
# Both lua and luac are invoked at build time
BDEPEND="${LUA_DEPS}
	app-text/asciidoc
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-cmake_lua_version.patch
)

src_prepare(){
	cmake_src_prepare
	# fix examples directory
	sed -i "s@examples DESTINATION doc@examples DESTINATION share/doc/${PF}/examples@" \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DLUA_ABI_VERSION=$(ver_cut 1-2 $(lua_get_version))
	)
	cmake_src_configure
}
