# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="A Stringprep Profile for User Names and Passwords (RFC 4013)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Unicode-Stringprep-1
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.350.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"
