# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 14 15 16 )

inherit git-r3 postgres-multi

DESCRIPTION="Open-source postgresql extension for clustering/multi-node setups"
HOMEPAGE="https://www.citusdata.com/"

EGIT_REPO_URI="https://github.com/citusdata/citus.git"

IUSE=""
LICENSE="POSTGRESQL AGPL-3"

KEYWORDS=""

SLOT=0

RESTRICT="test"

DEPEND="${POSTGRES_DEP}
	app-arch/lz4
	app-arch/zstd
	"
RDEPEND="${DEPEND}"

src_configure() {
	postgres-multi_foreach econf
}
