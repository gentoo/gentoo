# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="REL${PV//./_}"
POSTGRES_COMPAT=( 14 15 16 17 18 )
POSTGRES_USEDEP="server(+)"

inherit postgres-multi

DESCRIPTION="Statistics about physical disk access and CPU consumption done by backends"
HOMEPAGE="https://github.com/powa-team/pg_stat_kcache"
SRC_URI="https://github.com/powa-team/pg_stat_kcache/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${POSTGRES_REQ_USE}"

RDEPEND="${POSTGRES_DEP}"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_install() {
	einstalldocs
	postgres-multi_src_install
}
