# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Address-List/Email-Address-List-0.50.0.ebuild,v 1.1 2014/05/28 12:16:03 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ALEXMV
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="RFC close address list parsing"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Email-Address
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
