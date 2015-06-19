# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBIx-Class-InflateColumn-IP/DBIx-Class-InflateColumn-IP-0.20.30.ebuild,v 1.2 2014/10/11 20:45:16 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ILMARI
MODULE_VERSION=0.02003
inherit perl-module

DESCRIPTION="Auto-create NetAddr::IP objects from columns"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/NetAddr-IP
	>=dev-perl/DBIx-Class-0.81.70
"
DEPEND="${RDEPEND}"
