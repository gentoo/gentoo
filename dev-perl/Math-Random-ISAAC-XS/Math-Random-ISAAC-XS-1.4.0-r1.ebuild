# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-Random-ISAAC-XS/Math-Random-ISAAC-XS-1.4.0-r1.ebuild,v 1.2 2015/06/13 22:15:32 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JAWNSY
MODULE_VERSION=1.004
inherit perl-module

DESCRIPTION="C implementation of the ISAAC PRNG algorithm"

LICENSE="|| ( public-domain Artistic Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-perl/Math-Random-ISAAC"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-NoWarnings
	)"

SRC_TEST="do"
