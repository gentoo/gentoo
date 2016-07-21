# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JGOULAH
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Automatically set update and create user id fields"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Class-Accessor-Grouped
	dev-perl/DBIx-Class-DynamicDefault
	dev-perl/DBIx-Class"
RDEPEND="${DEPEND}"
