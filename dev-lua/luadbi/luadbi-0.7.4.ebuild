# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="A database interface library for Lua"
HOMEPAGE="https://github.com/mwild1/luadbi"
SRC_URI="https://github.com/mwild1/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="mysql postgres +sqlite test"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	|| ( mysql postgres sqlite )
"
RESTRICT="test"

RDEPEND="
	${LUA_DEPS}
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		dev-lua/luarocks
	)
"

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-g //' -e 's/-O2 //g' -i Makefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	tc-export AR CC

	local myemakeargs=(
		"LUA_INC=$(lua_get_CFLAGS)"
	)

	use mysql && emake ${myemakeargs} MYSQL_INC="-I$(mariadb_config --libs)" mysql
	use postgres && emake ${myemakeargs} PSQL_INC="-I$(pg_config --libdir)" psql
	use sqlite emake ${myemakeargs} SQLITE3_INC="-I/usr/include" sqlite

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die
	cd "${S}"/tests && ${ELUA} run_tests.lua || die
	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		DESTDIR="${ED}"
		LUA_CDIR="$(lua_get_cmod_dir)"
		LUA_INC="$(lua_get_CFLAGS)"
		LUA_LDIR="$(lua_get_lmod_dir)"
	)

	use mysql && emake ${myemakeargs[@]} install_mysql
	use postgres && emake ${myemakeargs[@]} install_psql
	use sqlite && emake ${myemakeargs[@]} install_sqlite3

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
