# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSCHWERN
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Base class for virtual base classes"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~x86-solaris"
IUSE="test"

RDEPEND=">=dev-perl/Class-Data-Inheritable-0.20.0
	>=dev-perl/Carp-Assert-0.100.0
	>=dev-perl/Class-ISA-0.31"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
