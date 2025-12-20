# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CLKAO
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="IO::Digest - Calculate digests while reading or writing"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND=">=dev-perl/PerlIO-via-dynamic-0.10"
BDEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
