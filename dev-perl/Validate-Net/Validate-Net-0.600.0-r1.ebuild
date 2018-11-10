# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=0.6
inherit perl-module

DESCRIPTION="Format validation and more for Net:: related strings"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc x86"
IUSE="test"

RDEPEND="dev-perl/Class-Default"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
