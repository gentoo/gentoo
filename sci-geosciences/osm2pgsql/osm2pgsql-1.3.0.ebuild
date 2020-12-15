# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="https://osm2pgsql.org/"
SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lua luajit"

COMMON_DEPEND="
	app-arch/bzip2
	dev-db/postgresql:=
	dev-libs/expat
	sci-libs/proj:=
	sys-libs/zlib
	lua? ( dev-lang/lua:0= )
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
