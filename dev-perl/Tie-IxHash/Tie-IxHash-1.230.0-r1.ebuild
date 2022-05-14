# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHORNY
DIST_VERSION=1.23
inherit perl-module

DESCRIPTION="Ordered associative arrays for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=""
BDEPEND="
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
