# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/openstreetmap/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake lua-single

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="https://osm2pgsql.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
REQUIRED_USE="${LUA_REQUIRED_USE}"

# Tries to connect to local postgres server and other shenanigans
RESTRICT="test"

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
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	dev-db/postgis
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-cmake_lua_version.patch
	"${FILESDIR}"/${P}-cmake-boost-warning.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_LUAJIT=$(usex lua_single_target_luajit)
		-DBUILD_TESTS=OFF
	)
	# To prevent the "unused variable" QA warning
	use lua_single_target_luajit || mycmakeargs+=( -DLUA_VERSION=$(lua_get_version) )

	cmake_src_configure
}
