# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Acceptance tests for Future::IO implementations"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/perl-Test2-Suite"
BDEPEND=">=dev-perl/Module-Build-0.400.400"
