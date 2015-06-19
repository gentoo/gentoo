# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-DBI-mysql/Class-DBI-mysql-1.0.0-r1.ebuild,v 1.1 2014/08/24 12:39:02 axs Exp $

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
