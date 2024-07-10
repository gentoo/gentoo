# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.009
inherit perl-module

DESCRIPTION="Wrapper for perl's configuration"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Data-Dumper
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.88
	)
"

src_test() {
	perl_rm_files t/release-pod-{syntax,coverage}.t
	perl-module_src_test
}
