# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE="Release"

POSTGRES_COMPAT=( {11..16} )
POSTGRES_USEDEP="server"

inherit cmake postgres-multi

DESCRIPTION="pgRouting extends PostGIS and PostgreSQL with geospatial routing functionality"
HOMEPAGE="https://pgrouting.org/"
LICENSE="GPL-2 MIT Boost-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/pgRouting/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE=""

RDEPEND="${POSTGRES_DEP}
	>=dev-db/postgis-2.0
	dev-libs/boost
	sci-mathematics/cgal
"

DEPEND="${RDEPEND}"
# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"

src_prepare() {
	cmake_src_prepare
	postgres-multi_src_prepare
}

my_src_configure() {
	local mycmakeargs=( -DPOSTGRESQL_BIN="$($PG_CONFIG --bindir)" )
	cmake_src_configure
}

src_configure() {
	postgres-multi_foreach my_src_configure
}

src_compile() {
	postgres-multi_foreach cmake_build
}

src_install() {
	postgres-multi_foreach cmake_src_install
}
