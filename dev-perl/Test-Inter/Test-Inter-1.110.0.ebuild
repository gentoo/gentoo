# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SBECK
DIST_VERSION=1.11
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Framework for more readable interactive test scripts"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.300.0"
RDEPEND="virtual/perl-IO"
DEPEND="${RDEPEND}"

src_test() {
	perl_rm_files t/pod_coverage.t t/pod.t t/_pod_coverage.t t/_pod.t
	perl-module_src_test
}
