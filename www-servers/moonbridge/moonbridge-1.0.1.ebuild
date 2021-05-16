# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{2,3} )

inherit lua-single

MYP=${PN}-v${PV}

DESCRIPTION="Network Server for Lua Applications"
HOMEPAGE="https://www.public-software-group.org/moonbridge"
SRC_URI="https://www.public-software-group.org/pub/projects/${PN}/v${PV}/${MYP}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"
DEPEND="
	${LUA_DEPS}
	dev-libs/libbsd"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/pmake
	virtual/pkgconfig"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

DOCS=( README reference.txt )

src_compile() {
	pmake CC=$(tc-getCC) LUA_INCLUDE="$(lua_get_include_dir)" \
		MOONBR_LUA_PATH=/usr/lib/moonbridge/?.lua \
		LUA_LIBRARY="$(lua_get_LIBS)" LUA_LIBDIR=/usr/$(get_libdir)
}

src_install() {
	einstalldocs
	docinto examples
	dodoc example_*
	dodoc helloworld.lua
	dobin ${PN}
	insinto /usr/lib/${PN}
	doins moonbridge_http.lua
	docompress -x /usr/share/doc/${PF}/examples
}
