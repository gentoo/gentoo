# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Generate syntax-hightlighted HTML for Perl using PPI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/CSS-Tiny-1.100.0
	>=dev-perl/PPI-0.990.0
	>=dev-perl/Params-Util-0.50.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	>=virtual/perl-File-Spec-0.800.0
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
