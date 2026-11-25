# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 15 16 17)

inherit git-r3 postgres-multi

DESCRIPTION="Open-source postgresql extension for clustering/multi-node setups"
HOMEPAGE="https://www.citusdata.com/"

EGIT_REPO_URI="https://github.com/citusdata/citus.git"

LICENSE="POSTGRESQL AGPL-3"
SLOT="0"
KEYWORDS=""
REQUIRED_USE="${POSTGRES_REQ_USE}"
RESTRICT="test"

DEPEND="${POSTGRES_DEP}
	app-arch/lz4
	app-arch/zstd
	"
RDEPEND="${DEPEND}"

src_configure() {
	postgres-multi_foreach econf
}
