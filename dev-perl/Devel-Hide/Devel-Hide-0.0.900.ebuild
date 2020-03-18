# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=FERREIRA
MODULE_VERSION=0.0009
inherit perl-module

DESCRIPTION="Forces the unavailability of specified Perl modules (for testing)"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~s390 ~sh ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_test() {
	perl_rm_files t/090pod.t t/098pod-coverage.t
	perl-module_src_test
}
