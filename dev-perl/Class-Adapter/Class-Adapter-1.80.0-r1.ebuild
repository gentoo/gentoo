# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.08
inherit perl-module

DESCRIPTION='Implementation of the "Adapter" Design Pattern'

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.10"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL /use lib q[.];\nuse inc::Module::Install::DSL /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
