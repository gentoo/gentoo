# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=REHSACK
DIST_VERSION=0.05

inherit perl-module

DESCRIPTION="Provide the stuff missing in Hash::Util"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? ( >=virtual/perl-Test-Simple-0.900.0 )
"
