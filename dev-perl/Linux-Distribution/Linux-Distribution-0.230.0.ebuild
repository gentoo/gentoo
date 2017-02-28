# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHORNY
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="Perl extension to detect on which Linux distribution we are running"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"
