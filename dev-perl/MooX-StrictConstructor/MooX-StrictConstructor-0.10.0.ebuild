# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=HARTZELL
DIST_VERSION=0.010
inherit perl-module

DESCRIPTION="Make your Moo-based object constructors blow up on unknown attributes"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Moo
	dev-perl/strictures"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Fatal )"
