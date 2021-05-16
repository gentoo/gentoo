# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

TBOX_PV="1.6.6"
LUAJIT_COMMIT="e9af1abec542e6f9851ff2368e7f196b6382a44c"
SV_COMMIT="9a3cf7c8e589de4f70378824329882c4a047fffc"
PDCURSES_COMMIT="5a522dc7ac23b8571f68851b844d3dd4dc6a67a5"
LUA_CJSON_COMMIT="515bab6d6d80b164b94db73af69609ea02f3a798"

DESCRIPTION="A cross-platform build utility based on Lua"
HOMEPAGE="https://xmake.io"
SRC_URI="
	https://github.com/xmake-io/xmake/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tboox/tbox/archive/v${TBOX_PV}.tar.gz -> tbox-${TBOX_PV}.tar.gz
	https://github.com/xmake-io/xmake-core-luajit/archive/${LUAJIT_COMMIT}.tar.gz -> xmake-core-luajit-${LUAJIT_COMMIT}.tar.gz
	https://github.com/xmake-io/xmake-core-sv/archive/${SV_COMMIT}.tar.gz -> xmake-core-sv-${SV_COMMIT}.tar.gz
	https://github.com/xmake-io/xmake-core-pdcurses/archive/${PDCURSES_COMMIT}.tar.gz -> xmake-core-pdcurses-${PDCURSES_COMMIT}.tar.gz
	https://github.com/xmake-io/xmake-core-lua-cjson/archive/${LUA_CJSON_COMMIT}.tar.gz -> xmake-core-lua-cjson-${LUA_CJSON_COMMIT}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	rmdir core/src/tbox/tbox || die
	mv ${WORKDIR}/tbox-${TBOX_PV} core/src/tbox/tbox
	rmdir core/src/luajit/luajit || die
	mv ${WORKDIR}/xmake-core-luajit-${LUAJIT_COMMIT} core/src/luajit/luajit
	rmdir core/src/sv/sv || die
	mv ${WORKDIR}/xmake-core-sv-${SV_COMMIT} core/src/sv/sv
	rmdir core/src/pdcurses/pdcurses || die
	mv ${WORKDIR}/xmake-core-pdcurses-${PDCURSES_COMMIT} core/src/pdcurses/pdcurses
	rmdir core/src/lua-cjson/lua-cjson || die
	mv ${WORKDIR}/xmake-core-lua-cjson-${LUA_CJSON_COMMIT} core/src/lua-cjson/lua-cjson
	sed -i '/chmod 777/d' makefile
	sed -i '/LDFLAGS_RELEASE/{s#-s##}' core/plat/linux/prefix.mak
}

src_compile() {
	emake build
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}

