# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.011
inherit perl-module

DESCRIPTION="Path::Tiny types and coercions for Moose"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Path-Tiny
	>=dev-perl/Moose-2.0.0
	dev-perl/MooseX-Types
	dev-perl/MooseX-Types-Stringlike
	virtual/perl-if
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.37.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		dev-perl/File-pushd
		dev-perl/Test-Fatal
		>=virtual/perl-File-Temp-0.180.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST="do parallel"
mytargets="install"
