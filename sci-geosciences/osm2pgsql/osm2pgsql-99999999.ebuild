# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/osm2pgsql/osm2pgsql-99999999.ebuild,v 1.12 2015/05/10 21:53:28 titanofold Exp $

EAPI=5

inherit autotools git-2

EGIT_REPO_URI="git://github.com/openstreetmap/osm2pgsql.git"
EGIT_BOOTSTRAP="eautoreconf"

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="http://wiki.openstreetmap.org/wiki/Osm2pgsql"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+lua +pbf"

DEPEND="
	app-arch/bzip2
	dev-db/postgresql:=
	dev-libs/boost
	dev-libs/libxml2:2
	sci-libs/geos
	sci-libs/proj
	sys-libs/zlib
	lua? ( dev-lang/lua:= )
	pbf? ( dev-libs/protobuf-c )
"
RDEPEND="${DEPEND}"
