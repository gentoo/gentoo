# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TODDR
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="Change and print terminal line settings"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~riscv s390 ~sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.350.0
	test? (
		virtual/perl-Test-Simple
	)"
SRC_TEST="do"

src_test() {
	perl_rm_files t/98-pod-coverage.t t/99-pod.t
	perl-module_src_test;
}
