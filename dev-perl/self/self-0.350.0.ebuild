# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=GUGOD
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="provides '\$self' in OO code"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	>=dev-perl/B-Hooks-Parser-0.80.0
	>=dev-perl/B-OPCheck-0.270.0
	>=dev-perl/Devel-Declare-0.3.4
	>=dev-perl/PadWalker-1.930.0
	dev-perl/Sub-Exporter
"
RDEPEND="${CDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0"
DEPEND="${CDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.420.0 )
"
