# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BKB
DIST_VERSION=0.47
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Read JSON into a Perl Variable"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Getopt-Long"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		virtual/perl-Encode
	)
"
