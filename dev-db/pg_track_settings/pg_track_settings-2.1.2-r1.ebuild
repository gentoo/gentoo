# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 14 15 16 17 18 )
POSTGRES_USEDEP="server(+)"

inherit postgres-multi

DESCRIPTION="Keeps track of PostgreSQL settings modification"
HOMEPAGE="https://github.com/rjuju/pg_track_settings"
SRC_URI="https://github.com/rjuju/pg_track_settings/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${POSTGRES_REQ_USE}"

RDEPEND="${POSTGRES_DEP}"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare() {
	# Workaround for PGXS install, Portage will install it anyway
	sed -e '/README.md/d' -i Makefile || die

	postgres-multi_src_prepare
}

src_install() {
	einstalldocs
	postgres-multi_src_install
}
