# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EXODIST
DIST_VERSION=0.000155
inherit perl-module

DESCRIPTION="A rich set of tools built upon the Test2 framework"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Module-Pluggable is just suggested now
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	>=dev-perl/Module-Pluggable-2.700.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Term-Table-0.13.0
	>=virtual/perl-Test-Simple-1.302.176
	virtual/perl-Time-HiRes
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
