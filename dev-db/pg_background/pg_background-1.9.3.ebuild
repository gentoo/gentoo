# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 14 15 16 17 18 )

inherit postgres-multi

DESCRIPTION="Postgres Background Worker"
HOMEPAGE="https://github.com/vibhorkum/pg_background"
SRC_URI="https://github.com/vibhorkum/pg_background/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${POSTGRES_REQ_USE}"
RESTRICT="test"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	postgres-multi_src_prepare
}
