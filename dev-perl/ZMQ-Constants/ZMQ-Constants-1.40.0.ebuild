# Copyright 1999-2017 Gentoo Foundation
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

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
