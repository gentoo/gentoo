# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.111017
inherit perl-module

DESCRIPTION="Create a minimal mirror of CPAN"

SLOT="0"
KEYWORDS="amd64 x86"

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
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
