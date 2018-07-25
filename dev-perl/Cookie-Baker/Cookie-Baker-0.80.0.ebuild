# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Cookie string generator / parser"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="test +xs"

RDEPEND="
	virtual/perl-Exporter
	dev-perl/URI
	xs? ( >=dev-perl/Cookie-Baker-XS-0.80.0 )
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Time
	)
"
