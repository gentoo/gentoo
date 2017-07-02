# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHORNY
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Heuristically determine the indent style"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? ( >=virtual/perl-Test-Simple-0.800.0 )
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL/use lib q[.];\nuse inc::Module::Install::DSL/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
