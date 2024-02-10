# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BKB
DIST_VERSION=0.62
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Read JSON into a Perl Variable"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Getopt-Long
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		virtual/perl-Encode
	)
"
