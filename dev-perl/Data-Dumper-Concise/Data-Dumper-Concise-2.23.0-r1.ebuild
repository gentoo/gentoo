# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=2.023
inherit perl-module

DESCRIPTION="Less indentation and newlines plus sub deparsing"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-solaris"

RDEPEND="
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
