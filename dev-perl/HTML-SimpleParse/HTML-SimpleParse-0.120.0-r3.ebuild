# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KWILLIAMS
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="Bare-bones HTML parser, similar to HTML::Parser"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
"
