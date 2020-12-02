# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A lua binding for the OpenLDAP client libraries"
HOMEPAGE="https://github.com/lualdap/lualdap"
SRC_URI="https://github.com/lualdap/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit test"
RESTRICT="test"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
	net-nds/openldap
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

HTML_DOCS=( "doc/us/." )

src_compile() {
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LBER_LIBDIR=/usr/$(get_libdir)"
		"LDAP_LIBDIR=/usr/$(get_libdir)"
		"LUA_INCDIR=$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))"
	)

	emake "${myemakeargs[@]}"
}

src_test() {
	LUA_CPATH="${S}/src/?.so" $(usex luajit 'luajit' 'lua') tests/test.lua
}

src_install() {
	# Workaround, as 'make install' does not create this directory
	dodir "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"

	local myemakeargs=(
		"DESTDIR=${ED}"
		"INST_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}
