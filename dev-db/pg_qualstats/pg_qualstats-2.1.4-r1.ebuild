# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 14 15 16 17 18 )
POSTGRES_USEDEP="server(+)"

inherit postgres-multi

DESCRIPTION="Statistics about predicates for helping finding what indices are missing"
HOMEPAGE="https://github.com/powa-team/pg_qualstats"
SRC_URI="https://github.com/powa-team/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${POSTGRES_REQ_USE}"

RDEPEND="${POSTGRES_DEP}"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare() {
	# README.md in 'root' is symlink only
	rm README.md || die
	mv doc/README.md . || die

	postgres-multi_src_prepare
}

src_install() {
	einstalldocs
	postgres-multi_src_install
}
