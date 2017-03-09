# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="An abstract Moose role for setting attributes from a configfile"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# MooseX::Types::Moose -> MooseX-Types
RDEPEND="
	virtual/perl-Carp
	dev-perl/Moose
	dev-perl/MooseX-Types
	>=dev-perl/MooseX-Types-Path-Tiny-0.5.0
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.7.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		dev-perl/Moose
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/Test-Requires
		dev-perl/Test-Without-Module
		virtual/perl-if
	)
"

# mytargets="install"
