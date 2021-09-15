# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANWAR
DIST_VERSION=1.46
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Create PDF documents in Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	>=dev-perl/File-Share-0.250.0
	dev-perl/JSON
	virtual/perl-Scalar-List-Utils
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/File-ShareDir-Install
	test? (
		virtual/perl-File-Temp
		>=dev-perl/Test-LeakTrace-0.140.0
		>=virtual/perl-Test-Simple-1.0.0
	)
"
