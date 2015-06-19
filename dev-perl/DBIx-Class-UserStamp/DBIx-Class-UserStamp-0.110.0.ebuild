# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBIx-Class-UserStamp/DBIx-Class-UserStamp-0.110.0.ebuild,v 1.2 2014/10/06 11:37:14 zlogene Exp $

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
