# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALEXP
DIST_VERSION=1.74
inherit perl-module

DESCRIPTION="Current top level domain names including new ICANN additions and ccTLDs"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
