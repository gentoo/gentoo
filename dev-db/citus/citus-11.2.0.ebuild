# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 13 14 15 )

inherit postgres-multi

DESCRIPTION="Open-source postgresql extension for clustering/multi-node setups"
HOMEPAGE="https://www.citusdata.com/"

MY_PV="${PV/beta0/beta}"
SRC_URI="https://github.com/citusdata/citus/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

IUSE=""
LICENSE="POSTGRESQL AGPL-3"

KEYWORDS="~amd64"

SLOT=0

RESTRICT="test"

DEPEND="${POSTGRES_DEP}
	app-arch/lz4
	app-arch/zstd
	"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/citus-11.2.0-redefine.patch

	postgres-multi_src_prepare
}

src_configure() {
	postgres-multi_foreach econf
}
