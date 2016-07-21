# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=KAZUHO
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="A simple prefork server framework"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Accessor-Lite-0.40.0
	dev-perl/List-MoreUtils
	>=dev-perl/Proc-Wait3-0.30.0
	dev-perl/Scope-Guard
	dev-perl/Signal-Mask
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		dev-perl/Test-Requires
		dev-perl/Test-SharedFork
	)
"
