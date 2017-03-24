# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=THINC
DIST_VERSION=0.28
DIST_EXAMPLES=( "example/*" )
inherit perl-module

DESCRIPTION="Flexibly parse strings and turn them into DateTime objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/DateTime
	>=dev-perl/DateTime-Format-Builder-0.740.0
	dev-perl/DateTime-TimeZone
	dev-perl/List-MoreUtils
	dev-perl/Module-Pluggable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-MockTime
		>=virtual/perl-Test-Simple-0.440.0
	)
"
src_test() {
	perl_rm_files t/002_pod.t t/003_podcoverage.t
	perl-module_src_test
}
