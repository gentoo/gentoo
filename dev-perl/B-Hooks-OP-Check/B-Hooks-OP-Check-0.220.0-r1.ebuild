# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Wrap OP check callbacks"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-parent"
BDEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
