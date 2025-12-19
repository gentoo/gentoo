# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=3.05
inherit perl-module

DESCRIPTION="Implementation of the soundex algorithm"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 x86 ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!minimal? ( dev-perl/Text-Unidecode )
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
