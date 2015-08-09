# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.56
inherit perl-module

DESCRIPTION="A Moose role for processing command line options"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Moose-0.560.0
	dev-perl/MooseX-Role-Parameterized
	>=dev-perl/Getopt-Long-Descriptive-0.81.0
	>=virtual/perl-Getopt-Long-2.370.0
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.310.0
	test? (
		dev-perl/Config-Any
		dev-perl/Path-Tiny
		>=dev-perl/Test-CheckDeps-0.2.0
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=dev-perl/Test-NoWarnings-1.40.0
		>=dev-perl/Test-Requires-0.50.0
		>=virtual/perl-Test-Simple-0.620.0
		dev-perl/Test-Trap
		>=dev-perl/Test-Warn-0.210.0
	)
"

SRC_TEST=do
