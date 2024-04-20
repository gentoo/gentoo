# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Make class syntax available"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

BDEPEND=">=dev-perl/Module-Build-0.400.400"
