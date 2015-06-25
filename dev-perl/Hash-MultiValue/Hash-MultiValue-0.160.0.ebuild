# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Hash-MultiValue/Hash-MultiValue-0.160.0.ebuild,v 1.1 2015/06/24 22:58:24 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ARISTOTLE
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="Store multiple values per key"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
