# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TSIBLEY
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Extract structure of quoted HTML mail message"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/HTML-Parser-3.0.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
