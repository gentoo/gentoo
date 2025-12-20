# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=2.22
inherit perl-module

DESCRIPTION="Testing TCP program"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

RDEPEND="
	virtual/perl-IO
	virtual/perl-IO-Socket-IP
	>=dev-perl/Test-SharedFork-0.290.0
	virtual/perl-Test-Simple
	virtual/perl-IO
	virtual/perl-Time-HiRes
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		virtual/perl-File-Temp
		virtual/perl-Socket
	)
"
