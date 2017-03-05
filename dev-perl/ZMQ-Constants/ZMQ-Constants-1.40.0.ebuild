# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DMAKI
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Constants for libzmq"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"

RDEPEND="
	net-libs/zeromq
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
"
