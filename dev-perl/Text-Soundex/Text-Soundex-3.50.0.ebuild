# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=3.05
inherit perl-module

DESCRIPTION="Implementation of the soundex algorithm"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? ( dev-perl/Text-Unidecode )
	virtual/perl-if
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
