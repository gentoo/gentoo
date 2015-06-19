# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Role-Basic/Role-Basic-0.130.0.ebuild,v 1.2 2014/08/04 20:10:54 zlogene Exp $

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Just roles. Nothing else"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
