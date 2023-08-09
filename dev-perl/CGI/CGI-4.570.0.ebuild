# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEEJO
DIST_VERSION=4.57
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Simple Common Gateway Interface Class"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
	>=virtual/perl-File-Spec-0.820.0
	>=virtual/perl-File-Temp-0.170.0
	>=dev-perl/HTML-Parser-3.690.0
	virtual/perl-if
	>=virtual/perl-parent-0.225.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		dev-perl/Test-NoWarnings
		>=virtual/perl-Test-Simple-0.980.0
		>=dev-perl/Test-Warn-0.300.0
	)
"

PERL_RM_FILES=( "t/compiles_pod.t" "t/changes.t" )
