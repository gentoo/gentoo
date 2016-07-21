# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Make your object constructors blow up on unknown attributes"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-perl/Moose-0.94
	dev-perl/namespace-autoclean"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31
	test? ( dev-perl/Test-Fatal )"

SRC_TEST=do
