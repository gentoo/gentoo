# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 3-0 )
inherit autotools guile

DESCRIPTION="Guile DBI driver for PostgreSQL"
HOMEPAGE="https://github.com/opencog/guile-dbi/"
SRC_URI="https://github.com/opencog/guile-dbi/archive/guile-dbi-${PV}.tar.gz"
S="${WORKDIR}"/guile-dbi-guile-dbi-${PV}/${PN}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	dev-db/postgresql:*
	>=dev-scheme/guile-dbi-2.1.9[${GUILE_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	guile_src_prepare

	eautoreconf
}

src_install() {
	guile_src_install

	find "${ED}" -type f -name "*.la" -delete || die
}
