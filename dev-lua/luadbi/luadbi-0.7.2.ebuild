# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A database interface library for Lua"
HOMEPAGE="https://github.com/mwild1/luadbi"
SRC_URI="https://github.com/mwild1/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 x86"
IUSE="mysql postgres +sqlite test"
REQUIRED_USE="|| ( mysql postgres sqlite )"
RESTRICT="test"

RDEPEND="
	>=dev-lang/lua-5.1:=
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite )
"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-0.7.2-mysql-8.patch" )

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-g //' -e 's/-O2 //g' -i Makefile || die
}

src_compile() {
	tc-export AR CC

	local myemakeargs=(
		"LUA_INC=-I$($(tc-getPKG_CONFIG) --variable INSTALL_INC lua)/lua5.1"
	)

	use mysql && emake ${myemakeargs} MYSQL_INC="-I$(mariadb_config --libs)" mysql
	use postgres && emake ${myemakeargs} PSQL_INC="-I$(pg_config --libdir)" psql
	use sqlite emake ${myemakeargs} SQLITE3_INC="-I/usr/include" sqlite
}

src_test() {
	cd "${S}"/tests && lua run_tests.lua || die
}

src_install() {
	local myemakeargs=(
		DESTDIR="${ED}"
		LUA_CDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"
		LUA_LDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	)

	use mysql && emake ${myemakeargs[@]} install_mysql
	use postgres && emake ${myemakeargs[@]} install_psql
	use sqlite && emake ${myemakeargs[@]} install_sqlite3
}
