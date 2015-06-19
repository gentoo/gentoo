# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MouseX-Types/MouseX-Types-0.60.0.ebuild,v 1.3 2015/03/29 11:49:36 zlogene Exp $

EAPI=5

MODULE_AUTHOR=GFUJI
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Organize your Mouse types in libraries"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Any-Moose-0.150.0
	>=dev-perl/Mouse-0.770.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
SRC_TEST="do parallel"
