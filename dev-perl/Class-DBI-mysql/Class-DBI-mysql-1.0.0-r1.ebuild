# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TMTM
MODULE_VERSION=1.00
inherit perl-module

DESCRIPTION="Extensions to Class::DBI for MySQL"

LICENSE="|| ( GPL-3 GPL-2 )" # GPL-2+
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

#Can't put tests here because they require interaction with the DB

RDEPEND="dev-perl/Class-DBI
	dev-perl/DBD-mysql"
DEPEND="${RDEPEND}"
