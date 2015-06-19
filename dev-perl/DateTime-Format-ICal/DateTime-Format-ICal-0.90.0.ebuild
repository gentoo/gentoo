# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-ICal/DateTime-Format-ICal-0.90.0.ebuild,v 1.3 2015/06/13 22:35:48 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Parse and format iCal datetime and duration strings"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/DateTime
	>=dev-perl/DateTime-Event-ICal-0.03
	>=dev-perl/DateTime-Set-0.1
	>=dev-perl/DateTime-TimeZone-0.22
	>=dev-perl/Params-Validate-0.59"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do
