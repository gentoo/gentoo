# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="UNIVERSAL::require - require() modules from a variable"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"
