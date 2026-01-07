# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REHSACK
DIST_VERSION=1.118
inherit perl-module

DESCRIPTION="Locate per-dist and per-module shared files"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!minimal? (
		>=dev-perl/List-MoreUtils-0.428.0
		>=dev-perl/Params-Util-1.70.0
	)
	>=dev-perl/Class-Inspector-1.120.0
	>=virtual/perl-File-Spec-0.800.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/File-ShareDir-Install-0.130.0
	test? (
		>=virtual/perl-File-Path-2.80.0
		>=virtual/perl-Test-Simple-0.900.0
	)
"
