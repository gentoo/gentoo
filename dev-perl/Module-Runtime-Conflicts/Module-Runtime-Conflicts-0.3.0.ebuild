# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.003
inherit perl-module

DESCRIPTION="Provide information on conflicts for Module::Runtime"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 ~sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Dist-CheckConflicts
	dev-perl/Module-Runtime
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-if
	)
"
