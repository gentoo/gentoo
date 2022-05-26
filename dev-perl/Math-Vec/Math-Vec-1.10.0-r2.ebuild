# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EWILHELM
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Vectors for perl"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"
