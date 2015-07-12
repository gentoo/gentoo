# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/App-cpanminus/App-cpanminus-1.703.900.ebuild,v 1.1 2015/07/12 15:06:06 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=1.7039
inherit perl-module

DESCRIPTION='Get, unpack, build and install modules from CPAN'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
