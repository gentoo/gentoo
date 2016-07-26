# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.111016
inherit perl-module

DESCRIPTION="Create a minimal mirror of CPAN"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/File-HomeDir-0.570.0
	>=virtual/perl-File-Path-2.40.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	>=virtual/perl-IO-Compress-1.20
	>=dev-perl/libwww-perl-5
	>=dev-perl/URI-1
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
