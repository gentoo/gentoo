# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ANDYA
MODULE_VERSION=0.17
inherit perl-module

DESCRIPTION="IPC::ShareLite module for perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( virtual/perl-Test-Simple )"
RDEPEND=""

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
