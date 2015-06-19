# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-Component-Client-DNS/POE-Component-Client-DNS-1.53.0.ebuild,v 1.1 2014/12/06 20:12:12 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=RCAPUTO
MODULE_VERSION=1.053
inherit perl-module

DESCRIPTION='Non-blocking, parallel DNS client'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Net-DNS-0.650.0
	>=dev-perl/POE-1.294.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-NoWarnings-1.20.0
	)
"

SRC_TEST="do"
