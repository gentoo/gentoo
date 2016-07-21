# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
