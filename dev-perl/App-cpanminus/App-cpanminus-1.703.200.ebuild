# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/App-cpanminus/App-cpanminus-1.703.200.ebuild,v 1.2 2015/06/13 19:27:09 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=1.7032
inherit perl-module

DESCRIPTION='Get, unpack, build and install modules from CPAN'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-ExtUtils-Install-1.460.0
	>=virtual/perl-ExtUtils-MakeMaker-6.580.0
	>=dev-perl/Module-Build-0.380.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
