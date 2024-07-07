# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCLAMP
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="Checks if the documentation of a module is comprehensive"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Pod-Parser-1.130.0
	>=dev-perl/Devel-Symdump-2.10.0
"

BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/07pod.t
	perl-module_src_test
}
