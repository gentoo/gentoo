# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="SALVA"
MODULE_VERSION="0.03"

inherit perl-module

DESCRIPTION="Sort IP v4 addresses"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-perl/Sort-Key-1.330.0"
