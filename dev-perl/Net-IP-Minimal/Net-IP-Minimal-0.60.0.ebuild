# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-IP-Minimal/Net-IP-Minimal-0.60.0.ebuild,v 1.1 2014/12/12 22:07:35 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=BINGOS
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION='Minimal functions from Net::IP'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

SRC_TEST="do"
