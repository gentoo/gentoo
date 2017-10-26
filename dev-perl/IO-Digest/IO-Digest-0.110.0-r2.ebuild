# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CLKAO
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="IO::Digest - Calculate digests while reading or writing"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND=">=dev-perl/PerlIO-via-dynamic-0.10
	virtual/perl-Digest"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
