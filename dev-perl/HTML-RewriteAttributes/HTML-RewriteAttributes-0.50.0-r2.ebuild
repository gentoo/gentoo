# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TSIBLEY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl module for concise attribute rewriting"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	dev-perl/URI
	dev-perl/HTML-Tagset
	dev-perl/HTML-Parser
"
BDEPEND="${RDEPEND}
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
