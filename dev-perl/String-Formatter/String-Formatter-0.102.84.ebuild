# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=0.102084
inherit perl-module

DESCRIPTION="build sprintf-like functions of your own"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Params-Util
	dev-perl/Sub-Exporter
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
PERL_RM_FILES=(
	"bench.pl" # https://github.com/rjbs/String-Formatter/issues/2
)
