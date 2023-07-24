# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=1.006002
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="An exporter with the features of Sub::Exporter but only core dependencies"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Warnings
		>=virtual/perl-Test-Simple-0.470.0
	)
"

PERL_RM_FILES=(
	inc/Test/Fatal.pm
	inc/Test/Requires.pm
	inc/Try/Tiny.pm
	inc/archaic/Test/Builder.pm
	inc/archaic/Test/Builder/IO/Scalar.pm
	inc/archaic/Test/Builder/Module.pm
	inc/archaic/Test/Builder/Tester.pm
	inc/archaic/Test/Builder/Tester/Color.pm
	inc/archaic/Test/More.pm
	inc/archaic/Test/Simple.pm
	SIGNATURE
)
