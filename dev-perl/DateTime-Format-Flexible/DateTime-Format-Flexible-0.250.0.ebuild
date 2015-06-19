# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-Flexible/DateTime-Format-Flexible-0.250.0.ebuild,v 1.3 2015/06/13 18:49:03 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=THINC
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="Flexibly parse strings and turn them into DateTime objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/DateTime
	>=dev-perl/DateTime-Format-Builder-0.74
	dev-perl/DateTime-TimeZone
	dev-perl/Module-Pluggable"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-MockTime
	)"

SRC_TEST=do
