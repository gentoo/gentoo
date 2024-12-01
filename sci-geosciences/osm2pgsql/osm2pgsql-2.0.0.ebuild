# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake lua-single

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="https://osm2pgsql.org/"
SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
REQUIRED_USE="${LUA_REQUIRED_USE}"

COMMON_DEPEND="
	app-arch/bzip2
	dev-db/postgresql:=
	dev-libs/expat
	sci-libs/proj:=
	sys-libs/zlib
	${LUA_DEPS}
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/nlohmann_json
	dev-libs/boost:=
"
RDEPEND="${COMMON_DEPEND}
	dev-db/postgis
"

# Tries to connect to local postgres server and other shenanigans
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-cmake_lua_version.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_LUAJIT=$(usex lua_single_target_luajit)
		# To prevent the "unused variable" QA warning
		$(usex !lua_single_target_luajit "-DLUA_VERSION=$(lua_get_version)" "")
		-DBUILD_TESTS=OFF
	)
	cmake_src_configure
}
