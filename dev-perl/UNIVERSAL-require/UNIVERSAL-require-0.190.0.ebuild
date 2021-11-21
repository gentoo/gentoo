# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="UNIVERSAL::require - require() modules from a variable"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"
