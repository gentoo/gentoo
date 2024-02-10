# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZUHO
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="A simple, high-performance PSGI/Plack HTTP server"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/Parallel-Prefork-0.170.0
	>=dev-perl/Plack-0.992.0
	>=dev-perl/Server-Starter-0.60.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/Test-TCP-2.100.0
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/libwww-perl
		>=virtual/perl-Test-Simple-0.880.0
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.];\n use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
