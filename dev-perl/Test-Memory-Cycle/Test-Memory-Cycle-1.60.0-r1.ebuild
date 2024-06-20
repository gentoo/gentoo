# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Check for memory leaks and circular memory references"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Devel-Cycle-1.70.0
	virtual/perl-Getopt-Long
	dev-perl/PadWalker
	>=virtual/perl-Test-Simple-0.620.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
