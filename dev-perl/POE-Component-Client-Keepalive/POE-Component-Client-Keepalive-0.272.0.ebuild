# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-Component-Client-Keepalive/POE-Component-Client-Keepalive-0.272.0.ebuild,v 1.1 2014/12/12 22:12:42 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=RCAPUTO
MODULE_VERSION=0.272
inherit perl-module

DESCRIPTION='Manage connections, with keep-alive'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Net-IP-Minimal-0.20.0
	>=dev-perl/POE-1.311.0
	>=dev-perl/POE-Component-Resolver-0.917.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

SRC_TEST="do"
