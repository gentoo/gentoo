# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/autobox/autobox-2.830.0.ebuild,v 1.1 2015/04/12 18:32:02 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=CHOCOLATE
MODULE_VERSION=2.83
inherit perl-module

DESCRIPTION="Call methods on native types"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Scope-Guard-0.200.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST=do
