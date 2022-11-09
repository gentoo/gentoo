# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="check that a command is available"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	virtual/perl-Exporter
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.980.0
	)
"
