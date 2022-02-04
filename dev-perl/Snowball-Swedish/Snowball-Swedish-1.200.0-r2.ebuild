# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ASKSH
DIST_VERSION=1.2
inherit perl-module

DESCRIPTION="Porters stemming algorithm for Swedish"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"
