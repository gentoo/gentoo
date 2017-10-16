# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.094001
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="read a POD document as a series of trivial events"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# r: strict, warnings -> perl
RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Mixin-Linewise-0.102.0
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Deep
	)
"
