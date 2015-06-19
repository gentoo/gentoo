# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/spatialite-tools/spatialite-tools-3.1.0.ebuild,v 1.1 2012/05/25 17:45:05 scarabeus Exp $

EAPI=4

inherit multilib

DESCRIPTION="A complete Spatial DBMS in a nutshell built upon sqlite"
HOMEPAGE="http://www.gaia-gis.it/spatialite"
SRC_URI="http://www.gaia-gis.it/gaia-sins/${PN}-sources/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="readline"

RDEPEND=">=dev-db/spatialite-3.0.1[geos,xls]
	dev-libs/expat
	>=sci-libs/geos-3.3
	sci-libs/proj
	sci-geosciences/readosm
	readline? (
		sys-libs/ncurses
		sys-libs/readline
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable readline)
}
