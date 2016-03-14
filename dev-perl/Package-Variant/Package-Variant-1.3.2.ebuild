# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MSTROUT
DIST_VERSION=1.003002
inherit perl-module

DESCRIPTION="Parameterizable packages"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/strictures-2.0.0
	>=dev-perl/Module-Runtime-0.13.0
	>=dev-perl/Import-Into-1.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
	)
"
