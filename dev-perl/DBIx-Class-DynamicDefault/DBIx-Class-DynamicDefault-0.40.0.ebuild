# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MSTROUT
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Automatically set and update fields"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/DBIx-Class-0.81.270
"
DEPEND="
	test? ( ${RDEPEND}
		virtual/perl-parent
		dev-perl/DBICx-TestDatabase
	)"

SRC_TEST="do"
