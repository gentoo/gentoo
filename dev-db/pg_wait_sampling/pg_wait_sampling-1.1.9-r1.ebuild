# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 14 15 16 17 18 )
POSTGRES_USEDEP="server(+)"

inherit postgres-multi

DESCRIPTION="Sampling based statistics of wait events"
HOMEPAGE="https://github.com/postgrespro/pg_wait_sampling"
SRC_URI="https://github.com/postgrespro/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${POSTGRES_REQ_USE}"

RDEPEND="${POSTGRES_DEP}"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_compile() {
	export USE_PGXS="1"
	postgres-multi_src_compile
}

src_install() {
	einstalldocs
	postgres-multi_src_install
}
