# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-HiRes/DateTime-HiRes-0.10.0.ebuild,v 1.3 2015/06/13 22:36:53 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JHOBLITT
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Create DateTime objects with sub-second current time resolution"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/DateTime"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
