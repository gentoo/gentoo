# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EXODIST
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="Ensure that tests work correctly when fork() is used"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"

RDEPEND="
	virtual/perl-File-Temp
	>=virtual/perl-Test-Simple-0.880.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-Test-Harness
		dev-perl/Test-Requires
		virtual/perl-Time-HiRes
	)
"
