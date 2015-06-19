# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Event-ICal/DateTime-Event-ICal-0.120.0.ebuild,v 1.1 2015/05/03 13:39:25 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=FGLOCK
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Perl DateTime extension for computing rfc2445 recurrences"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/DateTime
	>=dev-perl/DateTime-Event-Recurrence-0.110.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST=do
