# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=2.023
inherit perl-module

DESCRIPTION="Less indentation and newlines plus sub deparsing"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
