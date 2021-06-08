# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=EXODIST
DIST_VERSION=0.000140
inherit perl-module

DESCRIPTION="A rich set of tools built upon the Test2 framework"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	>=dev-perl/Importer-0.24.0
	>=dev-perl/Module-Pluggable-2.700.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Scope-Guard
	>=dev-perl/Sub-Info-0.2.0
	>=dev-perl/Term-Table-0.13.0
	>=virtual/perl-Test-Simple-1.302.176
	virtual/perl-Time-HiRes
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
