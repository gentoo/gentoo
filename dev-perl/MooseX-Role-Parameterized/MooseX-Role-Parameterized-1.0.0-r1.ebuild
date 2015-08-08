# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SARTAK
MODULE_VERSION=1.00
inherit perl-module

DESCRIPTION="Roles with composition parameters"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x64-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/Moose-2.30.0
"
DEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Fatal
	)
"
SRC_TEST="do"
