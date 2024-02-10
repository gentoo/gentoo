# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=0.88
inherit perl-module

DESCRIPTION="Generic archive extracting mechanism"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	virtual/perl-File-Path
	>=virtual/perl-File-Spec-0.820.0
	>=virtual/perl-IPC-Cmd-0.640.0
	virtual/perl-Locale-Maketext-Simple
	>=virtual/perl-Module-Load-Conditional-0.660.0
	>=virtual/perl-Params-Check-0.70.0
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
