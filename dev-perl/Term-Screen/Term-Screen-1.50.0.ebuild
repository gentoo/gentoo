# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JSTOWE
DIST_VERSION=1.05
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="A simple Term::Cap based screen positioning module"

SLOT="0"
KEYWORDS="amd64 s390 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
