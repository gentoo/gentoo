# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_VERSION=0.30
MODULE_AUTHOR=TSIBLEY
inherit perl-module

DESCRIPTION="Generate pronounceable passwords"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

src_test() {
	perl_rm_files t/99pod.t t/99pod-coverage.t
	perl-module_src_test
}
