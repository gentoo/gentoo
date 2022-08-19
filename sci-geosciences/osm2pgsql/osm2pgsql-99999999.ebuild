# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake git-r3 lua-single

EGIT_REPO_URI="https://github.com/openstreetmap/${PN}.git"

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="https://osm2pgsql.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+lua"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

COMMON_DEPEND="
	app-arch/bzip2
	dev-db/postgresql:=
	dev-libs/expat
	sci-libs/proj:=
	sys-libs/zlib
	lua? ( ${LUA_DEPS} )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost:=
"
RDEPEND="${COMMON_DEPEND}
	dev-db/postgis
"

# Tries to connect to local postgres server and other shenanigans
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-cmake_lua_version.patch
)

src_configure() {
	# Setting WITH_LUAJIT without "if use lua" guard is safe, upstream
	# CMakeLists.txt only evaluates it if WITH_LUA is true.
	local mycmakeargs=(
		-DWITH_LUA=$(usex lua)
		-DWITH_LUAJIT=$(usex lua_single_target_luajit)
		-DBUILD_TESTS=OFF
	)
	# To prevent the "unused variable" QA warning
	if use lua && ! use lua_single_target_luajit; then
		mycmakeargs+=( -DLUA_VERSION="$(lua_get_version)" )
	fi
	cmake_src_configure
}
