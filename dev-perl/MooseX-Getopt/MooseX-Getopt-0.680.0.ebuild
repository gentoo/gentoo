# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.68
inherit perl-module

DESCRIPTION="A Moose role for processing command line options"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Getopt-Long-2.370.0
	>=dev-perl/Getopt-Long-Descriptive-0.88.0
	dev-perl/Moose
	dev-perl/MooseX-Role-Parameterized
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? (
		virtual/perl-File-Spec
		dev-perl/Module-Runtime
		>=dev-perl/Path-Tiny-0.9.0
		dev-perl/Test-Deep
		>=dev-perl/Test-Fatal-0.3.0
		virtual/perl-Test-Simple
		dev-perl/Test-Requires
		dev-perl/Test-Trap
		>=dev-perl/Test-Warnings-0.9.0
		virtual/perl-if
	)
"
