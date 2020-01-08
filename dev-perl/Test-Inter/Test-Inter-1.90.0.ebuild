# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SBECK
DIST_VERSION=1.09
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Framework for more readable interactive test scripts"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.300.0"
RDEPEND="virtual/perl-IO"
DEPEND="${RDEPEND}
	test? (
		dev-perl/File-Find-Rule
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod_coverage.t t/pod.t
	perl-module_src_test
}
