# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=1.38
inherit perl-module

DESCRIPTION="Find a minimum required version of perl for Perl code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/File-Find-Rule
	dev-perl/File-Find-Rule-Perl
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	>=dev-perl/PPI-1.215.0
	>=dev-perl/PPIx-Regexp-0.33.0
	>=dev-perl/Params-Util-0.250.0
	>=dev-perl/Perl-Critic-1.104.0
	>=virtual/perl-Scalar-List-Utils-1.200.0
	>=virtual/perl-version-0.760.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Script-1.30.0
		>=virtual/perl-Test-Simple-0.470.0
	)
"
