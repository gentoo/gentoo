# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Template-Plugin-Cycle/Template-Plugin-Cycle-1.60.0.ebuild,v 1.2 2014/12/07 13:09:16 zlogene Exp $

EAPI=5

MODULE_AUTHOR="ADAMK"
MODULE_VERSION="1.06"

inherit perl-module

DESCRIPTION="Cyclically insert into a Template from a sequence of values"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-perl/Params-Util-1.60.0
	>=dev-perl/Template-Toolkit-2.240.0"
