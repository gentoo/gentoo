# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Module-Util/Module-Util-1.90.0.ebuild,v 1.2 2015/06/13 22:27:53 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MATTLAW
MODULE_VERSION=1.09
inherit perl-module

DESCRIPTION="Module name tools and transformations"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	>=dev-perl/Module-Build-0.400.0
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
