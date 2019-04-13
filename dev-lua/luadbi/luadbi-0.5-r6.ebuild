# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="DBI module for Lua"
HOMEPAGE="https://code.google.com/p/luadbi/"
SRC_URI="https://luadbi.googlecode.com/files/${PN}.${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="mysql postgres +sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND=">=dev-lang/lua-5.1
		mysql? ( dev-db/mysql-connector-c:0= )
		postgres? ( dev-db/postgresql )
		sqlite? ( >=dev-db/sqlite-3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${PV}-r2-Makefile.patch )

src_prepare() {
	default
	local pkgconf=$(tc-getPKG_CONFIG)
	sed -i -e "s#^INSTALL_DIR_LUA=.*#INSTALL_DIR_LUA=$(${pkgconf} --variable INSTALL_LMOD lua)#" \
		-e "s#^INSTALL_DIR_BIN=.*#INSTALL_DIR_BIN=$(${pkgconf} --variable INSTALL_CMOD lua)#" \
		-e "s#^LUA_INC_DIR=.*#LUA_INC_DIR=$(${pkgconf} --variable INSTALL_INC lua)#" \
		-e "s#^LUA_LIB_DIR=.*#LUA_LIB_DIR=$(${pkgconf} --variable INSTALL_LIB lua)#" \
		-e "s#^LUA_LIB =.*#LUA_LIB=lua#" Makefile || die

	drivers=""

	if use mysql; then
		drivers+="mysql "
		sed -i -e "s#^\(INCLUDES.*\)#\1 $(mysql_config --include)#" \
			-e "s#^\(MYSQL_LDFLAGS=\$(COMMON_LDFLAGS)\).*#\1 $(mysql_config --libs)#" Makefile || die
	fi

	if use postgres; then
		drivers+="psql "
		sed -i -e "s#^\(INCLUDES.*\)#\1 -I$(pg_config --includedir) -I$(pg_config --includedir-server)#" \
			-e "s#^\(PSQL_LDFLAGS=\$(COMMON_LDFLAGS)\).*#\1 -L$(pg_config --libdir) -lpq#" Makefile || die
	fi

	use sqlite && drivers+="sqlite3"
}

src_compile() {
	append-flags -fPIC
	for driver in ${drivers}; do
		emake CC="$(tc-getCC)" COMMON_LDFLAGS="${LDFLAGS}" ${driver}
	done
}

src_install() {
	for driver in ${drivers}; do
		emake DESTDIR="${D}" "install_${driver// /}"
	done
}
