# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="Faster implementation of HTTP::Headers"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	dev-perl/HTTP-Date
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Requires
	)
"
