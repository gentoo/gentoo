# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.{2..6} 10 )

inherit postgres-multi

DESCRIPTION="Unit testing for PostgreSQL"
HOMEPAGE="http://pgtap.org/"
SRC_URI="http://api.pgxn.org/dist/${PN}/${PV}/${P}.zip"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${POSTGRES_DEP}
		dev-perl/TAP-Parser-SourceHandler-pgTAP
"
RDEPEND="${DEPEND}"

src_configure() {
	:
}
