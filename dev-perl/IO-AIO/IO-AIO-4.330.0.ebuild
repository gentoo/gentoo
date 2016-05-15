# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=4.33
inherit perl-module

DESCRIPTION="Asynchronous Input/Output"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
# Tests trigger stack overflow in sandbox code, see bug 553918
RESTRICT="test"

RDEPEND="dev-perl/common-sense"
DEPEND="${RDEPEND}
	>=dev-perl/Canary-Stability-2001
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"
