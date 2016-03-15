# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MATTP
MODULE_VERSION=0.001007
inherit perl-module

DESCRIPTION="NativeTrait-like behavior for Moo"

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="test"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	>=dev-perl/Data-Perl-0.2.6
	dev-perl/Module-Runtime
	>=dev-perl/Moo-1.3.0
	dev-perl/Role-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/MooX-Types-MooseLike-0.230.0
		dev-perl/Test-Exception
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do
