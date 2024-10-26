# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

DESCRIPTION="Guile tooling to create and publish projects"
HOMEPAGE="https://gitlab.com/a-sassmannshausen/guile-hall/"
SRC_URI="https://gitlab.com/a-sassmannshausen/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	>=dev-scheme/guile-config-0.5.1-r100[${GUILE_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	guile_src_prepare

	sed -i -e "s|@verbatiminclude |@verbatiminclude ${S}/|" doc/hall.texi || die

	eautoreconf
}
