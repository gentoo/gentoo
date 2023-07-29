# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSAVAGE
DIST_VERSION=2.29
DIST_A_EXT="tgz"
inherit perl-module

DESCRIPTION="Read/Write .ini style files with as little code as possible"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-File-Spec-3.300.0
	>=virtual/perl-File-Temp-0.220.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.1.2
	)
"
