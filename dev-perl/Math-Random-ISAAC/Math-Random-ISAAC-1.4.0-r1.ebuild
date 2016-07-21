# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JAWNSY
MODULE_VERSION=1.004
inherit perl-module

DESCRIPTION="Perl interface to the ISAAC PRNG algorithm"

LICENSE="|| ( public-domain MIT Artistic Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

PDEPEND="dev-perl/Math-Random-ISAAC-XS"
RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-NoWarnings
	)"

SRC_TEST="do"
