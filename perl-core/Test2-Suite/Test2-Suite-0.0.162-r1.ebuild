# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EXODIST
DIST_VERSION=0.000162
inherit perl-module

DESCRIPTION="Rich set of tools built upon the Test2 framework"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

# Module-Pluggable is just suggested now
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	>=dev-perl/Module-Pluggable-2.700.0
	>=virtual/perl-Scalar-List-Utils-1.130.0
	>=virtual/perl-Term-Table-0.13.0
	>=virtual/perl-Test-Simple-1.302.176
	virtual/perl-Time-HiRes
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
