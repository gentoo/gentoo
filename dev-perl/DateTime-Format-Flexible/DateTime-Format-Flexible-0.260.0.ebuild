# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-Flexible/DateTime-Format-Flexible-0.260.0.ebuild,v 1.2 2015/06/13 18:49:03 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=THINC
MODULE_VERSION=0.26
inherit perl-module

DESCRIPTION="Flexibly parse strings and turn them into DateTime objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/DateTime
	>=dev-perl/DateTime-Format-Builder-0.740.0
	dev-perl/DateTime-TimeZone
	dev-perl/List-MoreUtils
	dev-perl/Module-Pluggable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-MockTime
		>=virtual/perl-Test-Simple-0.440.0
	)
"

SRC_TEST=do
