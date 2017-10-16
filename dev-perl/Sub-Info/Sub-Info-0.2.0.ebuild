# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=0.002
inherit perl-module

DESCRIPTION="Tool for inspecting subroutines"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Importer-0.24.0
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-1.302.72
	)
"
