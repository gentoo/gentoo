# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DOY
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="Routines for manipulating stashes"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"

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

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	virtual/perl-Text-ParseWords
	test? (
		virtual/perl-IO
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"
