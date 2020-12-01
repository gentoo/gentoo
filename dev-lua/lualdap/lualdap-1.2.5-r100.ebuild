# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

DESCRIPTION="A lua binding for the OpenLDAP client libraries"
HOMEPAGE="https://github.com/lualdap/lualdap"
SRC_URI="https://github.com/lualdap/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="
	net-nds/openldap
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

HTML_DOCS=( "doc/us/." )

src_prepare() {
	default

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LBER_LIBDIR=/usr/$(get_libdir)"
		"LDAP_LIBDIR=/usr/$(get_libdir)"
		"LUA_INCDIR=$(lua_get_include_dir)"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die
	LUA_CPATH="./src/?.so" ${ELUA} tests/test.lua
	popd
}

src_install() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	# Workaround, as 'make install' does not create this directory
	dodir "$(lua_get_cmod_dir)"

	local myemakeargs=(
		"DESTDIR=${ED}"
		"INST_LIBDIR=$(lua_get_cmod_dir)"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
