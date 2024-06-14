# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 13 14 15 16 )

inherit postgres-multi

DESCRIPTION="Postgres Background Worker"
HOMEPAGE="https://github.com/vibhorkum/pg_background"
SRC_URI="https://github.com/vibhorkum/pg_background/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"

SLOT=0
KEYWORDS="~amd64"

RESTRICT="test"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_compile() {
	postgres-multi_foreach emake || die "emake failed"
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install
}
