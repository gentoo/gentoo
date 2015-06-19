# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-Natural/DateTime-Format-Natural-1.10.0-r1.ebuild,v 1.2 2015/06/13 22:36:35 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=SCHUBIGER
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Create machine readable date/time with natural parsing logic"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/boolean
	dev-perl/Clone
	dev-perl/DateTime
	dev-perl/DateTime-TimeZone
	dev-perl/Date-Calc
	virtual/perl-Getopt-Long
	dev-perl/Params-Validate
	dev-perl/List-MoreUtils
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		dev-perl/Module-Util
		dev-perl/Test-MockTime
	)
"

SRC_TEST=do
