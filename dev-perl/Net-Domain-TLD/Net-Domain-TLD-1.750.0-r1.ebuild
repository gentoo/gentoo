# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ALEXP
DIST_VERSION=1.75
inherit perl-module

DESCRIPTION="Current top level domain names including new ICANN additions and ccTLDs"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Storable
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
