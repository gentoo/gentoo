# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/strictures/strictures-2.0.0.ebuild,v 1.1 2015/04/06 23:03:45 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=2.000000
inherit perl-module

DESCRIPTION="Turn on strict and make all warnings fatal"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do
