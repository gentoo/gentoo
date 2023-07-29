# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.31
DIST_EXAMPLES=( "benchmarks/*" )
inherit perl-module

DESCRIPTION="Flexible system for validation of method/function call parameters"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/Module-Implementation
	>=virtual/perl-Scalar-List-Utils-1.110.0
	virtual/perl-XSLoader
"

BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.422.700
	>=virtual/perl-JSON-PP-2.273.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
