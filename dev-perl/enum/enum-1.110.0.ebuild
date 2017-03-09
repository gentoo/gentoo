# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=1.11
inherit perl-module

DESCRIPTION="C style enumerated types and bitmask flags in Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE=""

RDEPEND="virtual/perl-Carp"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
