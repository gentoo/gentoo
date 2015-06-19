# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Symbol-Global-Name/Symbol-Global-Name-0.50.0.ebuild,v 1.1 2014/05/28 12:14:30 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ALEXMV
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Finds name and type of a global variable"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.96 )
"

SRC_TEST="do"
