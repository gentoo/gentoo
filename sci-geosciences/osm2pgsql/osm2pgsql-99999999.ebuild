# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-2

EGIT_REPO_URI="git://github.com/openstreetmap/osm2pgsql.git"

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="http://wiki.openstreetmap.org/wiki/Osm2pgsql"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+lua"

DEPEND="
	app-arch/bzip2
	dev-db/postgresql:=
	dev-libs/expat
	dev-libs/boost
	sci-libs/geos
	sci-libs/proj
	sys-libs/zlib
	lua? ( dev-lang/lua:= )
"
RDEPEND="${DEPEND}"
