# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PERIGRIN
DIST_VERSION=1.12
inherit perl-module

DESCRIPTION="A Perl module that offers a simple to process namespaced XML names"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? ( virtual/perl-Test-Simple )
"
