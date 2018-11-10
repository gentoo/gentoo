# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALEXP
DIST_VERSION=1.75
inherit perl-module

DESCRIPTION="Current top level domain names including new ICANN additions and ccTLDs"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 ~sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
