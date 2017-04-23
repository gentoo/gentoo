# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

EGIT_REPO_URI="git://github.com/openstreetmap/osm2pgsql.git"

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="http://wiki.openstreetmap.org/wiki/Osm2pgsql"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+lua"

COMMON_DEPEND="
	app-arch/bzip2
	dev-db/postgresql:=
	dev-libs/expat
	sci-libs/proj
	sys-libs/zlib
	lua? ( dev-lang/lua:= )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	dev-db/postgis
"

# Tries to connect to local postgres server and other shenanigans
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		-DWITH_LUA=$(usex lua)
		-DBUILD_TESTS=OFF
	)
	cmake-utils_src_configure
}
