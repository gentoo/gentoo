# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Hash-MoreUtils/Hash-MoreUtils-0.20.0-r1.ebuild,v 1.2 2015/06/13 22:51:47 dilfridge Exp $

EAPI=5

MODULE_AUTHOR="REHSACK"
MODULE_VERSION=0.02

inherit perl-module

DESCRIPTION="Provide the stuff missing in Hash::Util"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do"
