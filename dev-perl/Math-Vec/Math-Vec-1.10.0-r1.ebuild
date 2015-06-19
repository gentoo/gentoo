# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-Vec/Math-Vec-1.10.0-r1.ebuild,v 1.2 2015/06/13 22:15:52 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=EWILHELM
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Vectors for perl"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"
