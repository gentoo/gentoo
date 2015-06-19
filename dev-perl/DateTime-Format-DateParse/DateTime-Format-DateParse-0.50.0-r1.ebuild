# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-DateParse/DateTime-Format-DateParse-0.50.0-r1.ebuild,v 1.2 2015/06/13 22:34:24 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JHOBLITT
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Parses Date::Parse compatible formats"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=">=dev-perl/DateTime-0.29
	dev-perl/DateTime-TimeZone
	dev-perl/TimeDate"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do
