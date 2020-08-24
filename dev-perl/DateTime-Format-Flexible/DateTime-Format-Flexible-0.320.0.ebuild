# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=THINC
DIST_VERSION=0.32
DIST_EXAMPLES=( "example/*" )
inherit perl-module

DESCRIPTION="Flexibly parse strings and turn them into DateTime objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/DateTime
	>=dev-perl/DateTime-Format-Builder-0.740.0
	dev-perl/DateTime-TimeZone
	dev-perl/List-MoreUtils
	dev-perl/Module-Pluggable
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-MockTime
		dev-perl/Test-NoWarnings
		>=virtual/perl-Test-Simple-0.440.0
	)
"
PERL_RM_FILES=(
	t/002_pod.t
	t/003_podcoverage.t
)
