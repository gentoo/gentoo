# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

EGIT_REPO_URI="https://github.com/openstreetmap/${PN}.git"

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="https://osm2pgsql.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+lua luajit"

COMMON_DEPEND="
	app-arch/bzip2
	dev-db/postgresql:=
	dev-libs/expat
	sci-libs/proj:=
	sys-libs/zlib
	lua? ( dev-lang/lua:= )
	luajit? ( dev-lang/luajit:= )
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
		-DWITH_LUAJIT=$(usex luajit)
		-DBUILD_TESTS=OFF
	)
	cmake_src_configure
}
