# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.08
inherit perl-module

DESCRIPTION="Roles with composition parameters"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x64-macos"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Module-Runtime
	>=dev-perl/Moose-2.30.0
	dev-perl/namespace-autoclean
	dev-perl/namespace-clean
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-Tiny-0.37.0
	test? (
		>=dev-perl/CPAN-Meta-Check-0.7.0
		virtual/perl-CPAN-Meta-Requirements
		virtual/perl-Data-Dumper
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		dev-perl/MooseX-Role-WithOverloading
		virtual/perl-Storable
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"

SRC_TEST="do"
mytargets="install"
