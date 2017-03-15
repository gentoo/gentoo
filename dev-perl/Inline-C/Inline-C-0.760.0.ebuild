# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=INGY
DIST_VERSION=0.76
inherit perl-module

DESCRIPTION="C Language Support for Inline"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ppc ~sparc ~x86"
IUSE="test"

DIST_TEST="do" # parallelism thwarted by race conditions

RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-7
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/Inline-0.790.0
	>=dev-perl/Parse-RecDescent-1.967.9
	>=dev-perl/Pegex-0.580.0
	!<dev-perl/Inline-0.510.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		dev-perl/File-Copy-Recursive
		dev-perl/IO-All
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Warn-0.230.0
		dev-perl/YAML-LibYAML
		virtual/perl-autodie
		>=virtual/perl-version-0.770.0
	)
"
