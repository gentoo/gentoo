# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Acceptance tests for Future::IO implementations"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-perl/Module-Build-0.400.400"
