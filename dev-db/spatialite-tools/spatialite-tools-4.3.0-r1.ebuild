# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A collection of CLI tools supporting SpatiaLite"
HOMEPAGE="https://www.gaia-gis.it/spatialite"
SRC_URI="https://www.gaia-gis.it/gaia-sins/${PN}-sources/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="readline"

RDEPEND="
	dev-db/sqlite:3[extensions(+)]
	>=dev-db/spatialite-3.0.1[geos,xls]
	dev-libs/expat
	dev-libs/libxml2
	sci-geosciences/readosm
	sci-libs/geos
	sci-libs/proj
	readline? (
		sys-libs/ncurses:=
		sys-libs/readline:=
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable readline)
}
