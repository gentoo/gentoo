# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-CPHash/Tie-CPHash-1.60.0.ebuild,v 1.1 2014/12/06 00:03:44 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=CJM
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION='Case preserving but case insensitive hash table'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
