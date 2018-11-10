# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Converts OSM data to SQL and insert into PostgreSQL db"
HOMEPAGE="https://wiki.openstreetmap.org/wiki/Osm2pgsql
		  https://github.com/openstreetmap/osm2pgsql"
SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
