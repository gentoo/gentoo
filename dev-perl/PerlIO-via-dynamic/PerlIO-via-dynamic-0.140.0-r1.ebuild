# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALEXMV
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Dynamic PerlIO layers"

SLOT="0"
KEYWORDS="alpha amd64 ~mips ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND=">=virtual/perl-File-Temp-0.14"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
