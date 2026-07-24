# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Make class syntax available"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-perl/Object-Pad-0.823.0"
BDEPEND=">=dev-perl/Module-Build-0.400.400"
