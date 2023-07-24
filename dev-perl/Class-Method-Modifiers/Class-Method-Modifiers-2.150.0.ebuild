# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=2.15
inherit perl-module

DESCRIPTION="Provides Moose-like method modifiers"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.36
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-if
	)
"
