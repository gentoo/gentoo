# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="Array::Window - Calculate windows/subsets/pages of arrays"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Params-Util"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_prepare() {
	sed -i -e 's/use inc::Module::Install /use lib q[.]; use inc::Module::Install /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
