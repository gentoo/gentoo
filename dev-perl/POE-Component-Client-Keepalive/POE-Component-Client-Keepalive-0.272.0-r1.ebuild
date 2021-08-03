# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCAPUTO
DIST_VERSION=0.272
inherit perl-module

DESCRIPTION='Manage connections, with keep-alive'
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Net-IP-Minimal-0.20.0
	>=dev-perl/POE-1.311.0
	>=dev-perl/POE-Component-Resolver-0.917.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"
