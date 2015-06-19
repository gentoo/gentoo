# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Snowball-Swedish/Snowball-Swedish-1.200.0-r1.ebuild,v 1.2 2015/06/13 22:03:58 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ASKSH
MODULE_VERSION=1.2
inherit perl-module

DESCRIPTION="Porters stemming algorithm for Swedish"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST="do"
