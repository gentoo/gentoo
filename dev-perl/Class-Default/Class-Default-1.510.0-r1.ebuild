# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.51
inherit perl-module

DESCRIPTION="Static calls apply to a default instantiation"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28"

SRC_TEST="do"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
