# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 3-0 2-2 )
inherit guile-single

DESCRIPTION="Haunt is a simple, functional, hackable static site generator"
HOMEPAGE="https://dthompson.us/projects/haunt.html"
SRC_URI="https://files.dthompson.us/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	$(guile_gen_cond_dep '
		dev-scheme/guile-reader[${GUILE_MULTI_USEDEP}]
		dev-scheme/guile-commonmark[${GUILE_MULTI_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
