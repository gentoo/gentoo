# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZUHO
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="A simple prefork server framework"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/Class-Accessor-Lite-0.40.0
	dev-perl/List-MoreUtils
	>=dev-perl/Proc-Wait3-0.30.0
	dev-perl/Scope-Guard
	dev-perl/Signal-Mask
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		dev-perl/Test-Requires
		dev-perl/Test-SharedFork
	)
"

PATCHES=( "${FILESDIR}/${P}-RT113449.patch" )

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
