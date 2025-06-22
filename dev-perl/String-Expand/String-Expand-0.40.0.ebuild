# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="string utility functions for expanding variables in self-referential sets"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-perl/Module-Build"
