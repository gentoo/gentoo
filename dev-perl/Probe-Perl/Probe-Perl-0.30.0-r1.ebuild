# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KWILLIAMS
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Information about the currently running perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( virtual/perl-Test )
"

PERL_RM_FILES=( t/author-critic.t )
