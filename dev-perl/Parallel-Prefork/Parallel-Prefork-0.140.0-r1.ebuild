# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=KAZUHO
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="A simple prefork server framework"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Proc-Wait3-0.30.0
	dev-perl/List-MoreUtils
	>=dev-perl/Class-Accessor-Lite-0.40.0
	dev-perl/Scope-Guard
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		dev-perl/Test-Requires
		dev-perl/Test-SharedFork
	)
"

SRC_TEST=do
