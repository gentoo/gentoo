# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="XS functions to assist in parsing sub-like syntax"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	>=dev-perl/File-ShareDir-1.0.0
"
BDEPEND="
	${BDEPEND}
	>=dev-perl/Module-Build-0.400.400
"
