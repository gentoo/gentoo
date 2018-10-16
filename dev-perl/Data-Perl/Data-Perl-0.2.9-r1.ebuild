# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MATTP
DIST_VERSION=0.002009
inherit perl-module

DESCRIPTION="Base classes wrapping fundamental Perl data types"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	dev-perl/List-MoreUtils
	virtual/perl-Scalar-List-Utils
	dev-perl/Module-Runtime
	dev-perl/Role-Tiny
	virtual/perl-parent
	dev-perl/strictures
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Output
	)
"
