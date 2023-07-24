# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.40
inherit perl-module

DESCRIPTION="Routines for manipulating stashes"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="minimal"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Dist-CheckConflicts-0.20.0
	virtual/perl-Getopt-Long
	>=dev-perl/Module-Implementation-0.60.0
	virtual/perl-Scalar-List-Utils
	!minimal? (
		>=dev-perl/Package-Stash-XS-0.260.0
	)
"
# conflicts:
#	!<=dev-perl/Class-MOP-1.08
#	!<=dev-perl/namespace-clean-0.18
#	!<=dev-perl/MooseX-Role-WithOverloading-0.80
#	!<=dev-perl/MooseX-Method-Signatures-0.360.0
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	dev-perl/CPAN-Meta-Check
	dev-perl/ExtUtils-HasCompiler
	virtual/perl-Text-ParseWords
	test? (
		virtual/perl-IO
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"
