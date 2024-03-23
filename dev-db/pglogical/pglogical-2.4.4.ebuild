# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

POSTGRES_COMPAT=( {12..16} )

RESTRICT="test" # connects to :5432 by default, not good

inherit postgres-multi

MY_PV=$(ver_rs 1- '_')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${PN}-REL${MY_PV}"

DESCRIPTION="Logical replication for PostgreSQL"
HOMEPAGE="https://github.com/2ndQuadrant/pglogical"
SRC_URI="https://github.com/2ndQuadrant/pglogical/archive/REL${MY_PV}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_compile() {
	postgres-multi_foreach emake USE_PGXS=1 || die "emake failed"
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
	postgres-multi_foreach dobin pglogical_create_subscriber
}
