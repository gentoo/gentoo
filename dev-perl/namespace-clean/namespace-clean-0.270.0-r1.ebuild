# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RIBASUSHI
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="Keep imports and functions out of your namespace"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-perl/B-Hooks-EndOfScope-0.120.0
	>=dev-perl/Package-Stash-0.230.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
