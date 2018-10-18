# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CFAERBER
DIST_VERSION=2.400
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Internationalizing Domain Names in Applications (IDNA)"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Unicode-Normalize
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"
