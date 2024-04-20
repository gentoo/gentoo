# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AZAWAWI
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Compile .po files to .mo files"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL/use lib q[.];\nuse inc::Module::Install::DSL/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
