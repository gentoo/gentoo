# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple interface from Lua to OpenLDAP"
HOMEPAGE="https://github.com/lualdap/lualdap"
SRC_URI="https://github.com/lualdap/lualdap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-lang/lua:0
	>=net-nds/openldap-2.3
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake CC=$(tc-getCC) \
		LBER_LIBDIR=/usr/$(get_libdir) LDAP_LIBDIR=/usr/$(get_libdir) \
		LUA_VERSION=`$(tc-getPKG_CONFIG) --variable V lua`
}

src_install() {
	exeinto `$(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua`
	doexe src/lualdap.so
	dodoc {NEWS,README}.md
}
