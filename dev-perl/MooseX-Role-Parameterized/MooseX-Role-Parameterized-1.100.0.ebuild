# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Roles with composition parameters"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x64-macos"
IUSE="test"

RDEPEND="
	!<=dev-perl/MooseX-Storage-0.460.0
	virtual/perl-Carp
	dev-perl/Module-Runtime
	>=dev-perl/Moose-2.30.0
	dev-perl/namespace-autoclean
	>=dev-perl/namespace-clean-0.190.0
"
DEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.37.0
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-CPAN-Meta-Requirements
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		dev-perl/MooseX-Role-WithOverloading
		virtual/perl-Storable
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
