# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GRANTG
DIST_VERSION=1.08
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A clone of the classic Eliza program"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
